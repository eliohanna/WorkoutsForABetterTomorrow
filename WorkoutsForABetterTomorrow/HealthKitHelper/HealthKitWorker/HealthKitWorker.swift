//
//  HealthKitWorker.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 27/09/2021.
//

import Foundation
import HealthKit
import Combine

/// This class has two purposes, first is to init the `HealthKitQuery` and execute it,
/// and second to observer any changes to the data, and execute the `HealthKitQuery` again
class HealthKitWorker {
	let healthStore = HKHealthStore()
	let query: HealthKitQuery
	var cancellableSet: Set<AnyCancellable> = Set()
	
	private var summarySubject = CurrentValueSubject<Double, Error>(0.0)
	var summaryPublisher: AnyPublisher<Double, Error> { summarySubject.eraseToAnyPublisher() }
	
	private lazy var observerQuery: HKObserverQuery? = {
		guard let sampleType = query.type.quantityType else { return nil }
		return HKObserverQuery(sampleType: sampleType,
							   predicate: query.queryPredicate,
							   updateHandler: { [weak self] (observerQuery, completion, error) in
								self?.handleUpdate(for: observerQuery, error: error)
								completion()
							   })
	}()
	
	init(startDate: Date, endDate: Date, queryType: HealthKitQuery.QueryType) {
		query = HealthKitQuery(startDate: startDate, endDate: endDate, type: queryType)
	}
	
	func performFetch() {
		guard let observerQuery = observerQuery else { return }
		
		healthStore.execute(observerQuery)
		executeQuery()
	}
	
	private func handleUpdate(for query: HKObserverQuery, error: Error?) {
		if let error = error {
			self.summarySubject.send(completion: .failure(error))
		} else {
			executeQuery()
		}
	}
	
	private func executeQuery() {
		query.execute(healthStore: healthStore)
			.sink(receiveCompletion: { [weak self] (completion) in
				if case .failure(let error) = completion {
					self?.summarySubject.send(completion: .failure(error))
				}
			}, receiveValue: { [weak self] (count) in
				self?.summarySubject.send(count)
			})
			.store(in: &cancellableSet)
	}
}

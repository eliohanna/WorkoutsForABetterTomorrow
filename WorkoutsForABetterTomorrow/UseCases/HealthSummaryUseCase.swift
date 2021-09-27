//
//  HealthSummaryUseCase.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 26/09/2021.
//

import Foundation
import HealthKitHelper
import Combine

protocol HealthSummaryUseCase {
	var healthSummaryPublisher: AnyPublisher<GoalsListHealthSummary?, Error> { get }
	func performFetch()
}

/// This class was created to abstract the calling, and handling of each of the `HealthKitWorker`s, one for `step`, one for `walkingDistance`, and one for `runningDistance`
/// This class has another purpose as well, to combine those 3 results into a single `GoalsListHealthSummary` instance
class DefaultHealthSummaryUseCase {
	// MARK: - private properties
	private var stepWorker: HealthKitWorker
	private var walkingDistanceWorker: HealthKitWorker
	private var runningDistanceWorker: HealthKitWorker
	private var cancellableSet: Set<AnyCancellable> = Set()
	private let healthSummarySubject = CurrentValueSubject<GoalsListHealthSummary?, Error>(nil)
	
	init() {
		let endDate = Date()
		let startDate = Calendar.current.startOfDay(for: Date())
		
		stepWorker = HealthKitWorker(startDate: startDate, endDate: endDate, queryType: .step)
		walkingDistanceWorker = HealthKitWorker(startDate: startDate, endDate: endDate, queryType: .walkingDistance)
		runningDistanceWorker = HealthKitWorker(startDate: startDate, endDate: endDate, queryType: .runningDistance)
		
		setupPublishers()
	}
	
	private func setupPublishers() {
		Publishers.CombineLatest3(stepWorker.summaryPublisher,
								  walkingDistanceWorker.summaryPublisher,
								  runningDistanceWorker.summaryPublisher)
			.map({ (stepSummary, walkingSummary, runningSummary) in
				return GoalsListHealthSummary(steps: stepSummary.value,
											  walkingDistance: walkingSummary.value,
											  runningDistance: runningSummary.value)
			})
			.assign(to: healthSummarySubject)
			.store(in: &cancellableSet)
	}
}

extension DefaultHealthSummaryUseCase: HealthSummaryUseCase {
	var healthSummaryPublisher: AnyPublisher<GoalsListHealthSummary?, Error> { healthSummarySubject.eraseToAnyPublisher() }
	
	func performFetch() {
		stepWorker.performFetch()
		walkingDistanceWorker.performFetch()
		runningDistanceWorker.performFetch()
	}
}

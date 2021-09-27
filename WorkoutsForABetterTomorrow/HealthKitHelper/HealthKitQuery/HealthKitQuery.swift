//
//  HealthKitQuery.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 27/09/2021.
//

import Foundation
import HealthKit
import Combine

extension HealthKitQuery {
	enum QueryType {
		case step
		case walkingDistance
		case runningDistance
		
		var quantityType: HKQuantityType? {
			switch self {
			case .step:
				return .quantityType(forIdentifier: .stepCount)
			case .walkingDistance, .runningDistance:
				return .quantityType(forIdentifier: .distanceWalkingRunning)
			}
		}
		
		var unit: HKUnit {
			switch self {
			case .step:
				return .count()
			case .walkingDistance, .runningDistance:
				return .meter()
			}
		}
	}
}

/// This  class is a wrapper around Apple's `HKStatisticsQuery`
/// It handles the creation of the query, as well as the result
/// Two special cases are handled here, `HKError.Code.errorNoData` and `HKError.Code.noError]`, for us these are not errors, but rather a value of 0
class HealthKitQuery {
	let startDate: Date
	let endDate: Date
	let type: QueryType
	
	lazy var queryPredicate: NSPredicate = {
		return HKQuery.predicateForSamples(withStart: startDate,
										   end: endDate,
										   options: [.strictStartDate, .strictEndDate])
	}()
	
	init(startDate: Date, endDate: Date, type: QueryType) {
		self.startDate = startDate
		self.endDate = endDate
		self.type = type
	}
	
	func execute(healthStore: HKHealthStore) -> Future<Double, Error> {
		return Future({ [weak self] completion in
			guard let quantityType = self?.type.quantityType else { return }
			let query = HKStatisticsQuery(
				quantityType: quantityType,
				quantitySamplePredicate: self?.queryPredicate,
				options: .cumulativeSum,
				completionHandler: { [weak self] (_, statistics, error) in
					guard let result = self?.handleResult(statistics: statistics, error: error) else { return }
					completion(result)
				}
			)
			
			healthStore.execute(query)
		})
	}
	
	private func handleResult(statistics: HKStatistics?, error: Error?) -> Result<Double, Error> {
		if let error = error as? HKError, [HKError.Code.errorNoData, HKError.Code.noError].contains(error.code) {
			return .success(0.0)
		}
		if let error = error {
			return .failure(error)
		}
		if let statistics = statistics, let quantity = statistics.sumQuantity() {
			let total = quantity.doubleValue(for: type.unit)
			return .success(total)
		}
		return .success(0.0)
	}
}

//
//  HealthKitPermissionManager.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 27/09/2021.
//

import Foundation
import Combine
import HealthKit

/// This class is responsible for handling the request `healthKitRequests` to the user
class HealthKitPermissionManager {
	private class var healthKitRequests: Set<HKObjectType> {
		return Set([
			HKObjectType.quantityType(forIdentifier: .stepCount),
			HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
		].compactMap({ $0 }))
	}
	
	class func authorizeHealthKit() -> Future<Bool, Error> {
		return Future({ completion in
			guard HKHealthStore.isHealthDataAvailable() else {
				completion(.failure(HealthKitError.notAuthorized))
				return
			}
			
			HKHealthStore().requestAuthorization(toShare: nil, read: healthKitRequests, completion: { (success, error) in
				if let error = error {
					completion(.failure(error))
				} else {
					completion(.success(success))
				}
			})
		})
	}
}

//
//  GoalsNetworkService.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 26/09/2021.
//

import Foundation
import Combine

protocol GoalsNetworkService {
	func fetchGoals() -> AnyPublisher<[Goal], Error>
}

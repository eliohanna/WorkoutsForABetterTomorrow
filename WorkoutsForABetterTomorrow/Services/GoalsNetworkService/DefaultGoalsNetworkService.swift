//
//  DefaultGoalsNetworkService.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 26/09/2021.
//

import Foundation
import Combine

/// This class uses the `NetworkService` to fetch the list of goals
class DefaultGoalsNetworkService {
	enum Paths: String {
		case getGoals = "/goals"
	}
	
	let networkService: NetworkService
	
	init(baseURL: URL) {
		self.networkService = NetworkService(baseURL: baseURL)
	}
}

extension DefaultGoalsNetworkService {
	func fetchGoals() -> AnyPublisher<[Goal], Error> {
		let publisher: AnyPublisher<GoalsResponseModel, Error> = networkService.dial(path: Paths.getGoals.rawValue)
		return publisher.map({ Goal.from(goalResponse: $0.goals) }).eraseToAnyPublisher()
	}
}

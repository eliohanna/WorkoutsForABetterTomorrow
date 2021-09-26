//
//  GoalsFetchingUseCase.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 26/09/2021.
//

import Foundation
import Combine

protocol GoalsFetchingUseCase {
	var goalsPublisher: AnyPublisher<[Goal], Error> { get }
	func performFetch()
}

/// This class was created to abstract the calling, and handling of the goals list API
/// This class has another purpose as well, to cache, and get the cached response of goals
class DefaultGoalsFetchingUseCase {
	// MARK: - private properties
	private let goalsService: DefaultGoalsNetworkService
	private let cache = GoalsCache()
	private let goals = PassthroughSubject<[Goal], Error>()
	private var cancellableSet: Set<AnyCancellable> = Set()
	
	// MARK: - init
	init(baseURL: URL) {
		goalsService = DefaultGoalsNetworkService(baseURL: baseURL)
	}
}

extension DefaultGoalsFetchingUseCase: GoalsFetchingUseCase {
	var goalsPublisher: AnyPublisher<[Goal], Error> { goals.eraseToAnyPublisher() }
	
	func performFetch() {
		if let cachedGoals = cache.get() {
			goals.send(cachedGoals)
		}
		goalsService.fetchGoals()
			.sink(receiveCompletion: { [weak self] completion in
				switch completion {
				case .failure(let error):
					self?.goals.send(completion: .failure(error))
				case .finished:
					break
				}
			}, receiveValue: { [weak self] result in
				self?.goals.send(result)
			})
			.store(in: &cancellableSet)
	}
}

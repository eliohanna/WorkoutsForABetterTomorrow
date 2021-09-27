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
	private let cache: CacheableGoalsUseCase
	private let goalsSubject = CurrentValueSubject<[Goal], Error>([])
	private var cancellableSet: Set<AnyCancellable> = Set()
	
	// MARK: - init
	init(baseURL: URL, cache: CacheableGoalsUseCase) {
		goalsService = DefaultGoalsNetworkService(baseURL: baseURL)
		self.cache = cache
	}
	
	private func goalsFetched(_ goals: [Goal]) {
		cache.save(goals: goals)
		goalsSubject.send(goals)
	}
}

extension DefaultGoalsFetchingUseCase: GoalsFetchingUseCase {
	var goalsPublisher: AnyPublisher<[Goal], Error> { goalsSubject.eraseToAnyPublisher() }
	
	func performFetch() {
		if let cachedGoals = cache.get() {
			goalsSubject.send(cachedGoals)
		}
		goalsService.fetchGoals()
			.replaceError(with: cache.get() ?? [])
			.sink(receiveValue: { [weak self] result in
				self?.goalsFetched(result)
			})
			.store(in: &cancellableSet)
	}
}

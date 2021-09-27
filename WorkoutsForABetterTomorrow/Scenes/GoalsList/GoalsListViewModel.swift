//
//  GoalsListViewModel.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 25/09/2021.
//

import Foundation
import HealthKitHelper
import Combine


protocol GoalsListViewModelProtocol {
	var goalListStatePublisher: AnyPublisher<GoalsListState, Never> { get }
	func viewDidLoad()
	func didSelectGoal(with goalDetails: Goal)
}

class GoalsListViewModel {
	// MARK: - private properties
	private let goalsFetchingUseCase: GoalsFetchingUseCase
	private let healthSummaryUseCase: HealthSummaryUseCase
	private var cancellableSet: Set<AnyCancellable> = Set()
	private var goalListStateSubject = CurrentValueSubject<GoalsListState, Never>(.loading)
	private var coordinator: GoalListCoordinator?
	
	// MARK: - init
	init(coordinator: GoalListCoordinator?, goalsFetchingUseCase: GoalsFetchingUseCase, healthSummaryUseCase: HealthSummaryUseCase) {
		self.coordinator = coordinator
		self.goalsFetchingUseCase = goalsFetchingUseCase
		self.healthSummaryUseCase = healthSummaryUseCase
	}
	
	// MARK: - helper functions
	
	/// calls `HealthKitPermissionManager.authorizeHealthKit()`
	/// - Returns: a `Publisher` of the authorization status
	private func authorizeHealthKit() -> AnyPublisher<Bool, Never> {
		HealthKitPermissionManager.authorizeHealthKit()
			.replaceError(with: false)
			.eraseToAnyPublisher()
	}
	
	private func fetchResults() {
		goalsFetchingUseCase.performFetch()
		healthSummaryUseCase.performFetch()
	}
	
	private func clearFetch() {
		cancellableSet.forEach({ $0.cancel() })
		cancellableSet.removeAll()
	}
	
	private func getViewModels(for goals: [Goal], summary: GoalsListHealthSummary) -> [GoalViewModel] {
		return goals.map({ goal -> GoalViewModel in
			return .init(goal: goal, currentHealthSummary: summary)
		})
	}
	
	/// - combines `healthSummaryUseCase.goalSummaryPublisher` and `goalsFetchingUseCase.goalsPublisher`
	/// - tries to map the result of combination into `GoalsListState`
	/// - sinks the value to `goalListStateSubject`
	private func setupPublishers() {
		Publishers.CombineLatest(healthSummaryUseCase.healthSummaryPublisher, goalsFetchingUseCase.goalsPublisher)
			.tryMap({ [weak self] (summary, goals) -> GoalsListState in
				guard let summary = summary else { return GoalsListState.failure(HealthKitError.notAuthorized) }
				let viewModels = self?.getViewModels(for: goals, summary: summary) ?? []
				return GoalsListState.success(goals: viewModels)
			})
			.sink(receiveCompletion: { [weak self] completion in
				if case .failure(let error) = completion {
					self?.goalListStateSubject.send(.failure(error))
				}
			}, receiveValue: { [weak self] state in
				self?.goalListStateSubject.send(state)
			})
			.store(in: &cancellableSet)
	}
	
	private func handleAuthorizationStatus(isAuthorized: Bool) {
		if isAuthorized {
			setupPublishers()
			fetchResults()
		} else {
			goalListStateSubject.send(.failure(HealthKitError.notAuthorized))
		}
	}
}

extension GoalsListViewModel: GoalsListViewModelProtocol {
	var goalListStatePublisher: AnyPublisher<GoalsListState, Never> { goalListStateSubject.eraseToAnyPublisher() }
	
	func viewDidLoad() {
		clearFetch()
		authorizeHealthKit()
			.sink(receiveValue: { [weak self] authorized in
				self?.handleAuthorizationStatus(isAuthorized: authorized)
			})
			.store(in: &cancellableSet)
	}
	
	func didSelectGoal(with goalDetails: Goal) {
		coordinator?.routeToGoalDetails(with: goalDetails)
	}
}

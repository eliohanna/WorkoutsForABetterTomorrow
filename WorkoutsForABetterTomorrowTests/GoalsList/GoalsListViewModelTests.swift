//
//  GoalsListViewModelTests.swift
//  WorkoutsForABetterTomorrowTests
//
//  Created by ElioHanna on 27/09/2021.
//

import XCTest
@testable import WorkoutsForABetterTomorrow
import HealthKitHelper
import Combine

class GoalsListViewModelTests: XCTestCase {
	var cancellableSet: Set<AnyCancellable> = Set()
	
	var goalsFetchingUseCase: MockGoalsFetchingUseCase?
	var healthSummaryUseCase: MockHealthSummaryUseCase?
	var viewModel: GoalsListViewModel?
	
	override func setUp() {
		goalsFetchingUseCase = MockGoalsFetchingUseCase()
		healthSummaryUseCase = MockHealthSummaryUseCase()
		
		viewModel = GoalsListViewModel(coordinator: nil,
									   goalsFetchingUseCase: goalsFetchingUseCase!,
									   healthSummaryUseCase: healthSummaryUseCase!)
	}
	
	override func tearDown() {
		cancellableSet = Set()
		
		viewModel = nil
		goalsFetchingUseCase = nil
		healthSummaryUseCase = nil
	}
	
	func testNotAuthorized() {
		let unauthorizedExpectation = expectation(description: "State should be unauthorized")
		
		viewModel?.goalListStatePublisher
			.receive(on: DispatchQueue.main)
			.sink(receiveValue: { state in
				if case .failure(let error) = state,
				   error.localizedDescription == HealthKitError.notAuthorized.localizedDescription {
					unauthorizedExpectation.fulfill()
				}
			})
			.store(in: &cancellableSet)
		
		viewModel?.viewDidLoad()
		
		healthSummaryUseCase?.expectedResult.send(completion: .failure(HealthKitError.notAuthorized))
		goalsFetchingUseCase?.expectedResult.send([])
		
		wait(for: [unauthorizedExpectation], timeout: 0.1)
	}
	
	func testStateFetched() {
		let goalsExpectation = expectation(description: "State should be success")
		
		let healthSummary = GoalsListHealthSummary.mock
		let mockGoals = Goal.mockGoals
		
		viewModel?.goalListStatePublisher
			.receive(on: DispatchQueue.main)
			.sink(receiveValue: { state in
				if case .success(let goals) = state {
					guard goals.map({ $0.goal }) == mockGoals,
						  goals.first?.currentHealthSummary == healthSummary else { return }
					goalsExpectation.fulfill()
				}
			})
			.store(in: &cancellableSet)
		
		viewModel?.viewDidLoad()
		
		healthSummaryUseCase?.expectedResult.send(healthSummary)
		goalsFetchingUseCase?.expectedResult.send(mockGoals)
		
		wait(for: [goalsExpectation], timeout: 0.1)
	}
	
	func testGoalsUpdated() {
		let goalsExpectation = expectation(description: "State should update")
		
		let healthSummary = GoalsListHealthSummary.mock
		let mockGoals = Goal.mockGoals
		let updatedMockGoals = Goal.mockGoals
		
		viewModel?.goalListStatePublisher
			.receive(on: DispatchQueue.main)
			.sink(receiveValue: { state in
				if case .success(let goals) = state {
					guard goals.map({ $0.goal }) == updatedMockGoals,
						  goals.first?.currentHealthSummary == healthSummary else { return }
					goalsExpectation.fulfill()
				}
			})
			.store(in: &cancellableSet)
		
		viewModel?.viewDidLoad()
		
		healthSummaryUseCase?.expectedResult.send(healthSummary)
		goalsFetchingUseCase?.expectedResult.send(mockGoals)
		
		goalsFetchingUseCase?.expectedResult.send(updatedMockGoals)
		
		wait(for: [goalsExpectation], timeout: 0.1)
	}
	
	func testHealthUpdated() {
		let goalsExpectation = expectation(description: "State should update")
		
		let healthSummary = GoalsListHealthSummary.mock
		let mockGoals = Goal.mockGoals
		let updatedHealthSummary = GoalsListHealthSummary.mock
		
		viewModel?.goalListStatePublisher
			.receive(on: DispatchQueue.main)
			.sink(receiveValue: { state in
				if case .success(let goals) = state {
					guard goals.map({ $0.goal }) == mockGoals,
						  goals.first?.currentHealthSummary == updatedHealthSummary else { return }
					goalsExpectation.fulfill()
				}
			})
			.store(in: &cancellableSet)
		
		viewModel?.viewDidLoad()
		
		healthSummaryUseCase?.expectedResult.send(healthSummary)
		goalsFetchingUseCase?.expectedResult.send(mockGoals)
		
		healthSummaryUseCase?.expectedResult.send(updatedHealthSummary)
		
		wait(for: [goalsExpectation], timeout: 10)
	}
}

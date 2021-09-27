//
//  GoalDetailsViewModelTests.swift
//  WorkoutsForABetterTomorrowTests
//
//  Created by ElioHanna on 27/09/2021.
//

import XCTest
@testable import WorkoutsForABetterTomorrow
import Combine

class GoalDetailsViewModelTests: XCTestCase {
	var cancellableSet: Set<AnyCancellable> = Set()
	
	var healthSummaryUseCase: MockHealthSummaryUseCase?
	var viewModel: GoalDetailsViewModel?
	
	override func setUp() {
		healthSummaryUseCase = MockHealthSummaryUseCase()
		
		viewModel = GoalDetailsViewModel(healthSummaryUseCase: healthSummaryUseCase!, currentGoal: .goal)
	}
	
	func cancel() {
		cancellableSet.forEach({ $0.cancel() })
		cancellableSet.removeAll()
	}
	
	override func tearDown() {
		cancel()
		
		viewModel = nil
		healthSummaryUseCase = nil
	}
	
	func testStateFetched() {
		let summaryExpectation = expectation(description: "Summary should be retrieved")
		
		let mockHealthSummary = GoalsListHealthSummary.mock
		
		viewModel?.$healthSummary
			.receive(on: DispatchQueue.main)
			.sink(receiveValue: { [weak self] healthSummary in
				guard healthSummary == mockHealthSummary else { return }
				summaryExpectation.fulfill()
				self?.cancel()
		})
		.store(in: &cancellableSet)
		
		viewModel?.viewDidAppear()
		
		healthSummaryUseCase?.expectedResult.send(mockHealthSummary)
		
		wait(for: [summaryExpectation], timeout: 0.5)
	}
	
	func testStateUpdated() {
		let summaryExpectation = expectation(description: "Summary should be retrieved")
		
		let mockHealthSummary = GoalsListHealthSummary.mock
		let updatedMockHealthSummary = GoalsListHealthSummary.mock
		
		viewModel?.$healthSummary
			.receive(on: DispatchQueue.main)
			.sink(receiveValue: { [weak self] healthSummary in
				guard healthSummary == updatedMockHealthSummary else { return }
				summaryExpectation.fulfill()
				self?.cancel()
		})
		.store(in: &cancellableSet)
		
		viewModel?.viewDidAppear()
		
		healthSummaryUseCase?.expectedResult.send(mockHealthSummary)
		healthSummaryUseCase?.expectedResult.send(updatedMockHealthSummary)
		
		wait(for: [summaryExpectation], timeout: 0.5)
	}
}

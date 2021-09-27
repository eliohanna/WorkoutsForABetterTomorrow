//
//  GoalDetailsViewModel.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 26/09/2021.
//

import Foundation
import Combine

class GoalDetailsViewModel: ObservableObject {
	
	var cancellableSet = Set<AnyCancellable>()
	let healthSummaryUseCase: HealthSummaryUseCase
	let currentGoal: Goal
	
	@Published var healthSummary: GoalsListHealthSummary?

	init(healthSummaryUseCase: HealthSummaryUseCase, currentGoal: Goal) {
		self.healthSummaryUseCase = healthSummaryUseCase
		self.currentGoal = currentGoal
		
		setupPublishers()
	}
	
	func setupPublishers() {
		healthSummaryUseCase
			.healthSummaryPublisher
			.replaceError(with: nil)
			.receive(on: DispatchQueue.main)
			.assignNoRetain(to: \.healthSummary, on: self)
			.store(in: &cancellableSet)
	}
	
	func viewDidAppear() {
		healthSummaryUseCase.performFetch()
	}
	
	var goalDescription: String {
		var metricValue: String {
			if case .step = currentGoal.type { return "steps" }
			return "meters"
		}
		
		return "\(Int(currentGoal.goal)) \(metricValue)"
	}
	
	var progress: Double {
		guard let healthSummary = healthSummary else { return 0.0 }
		return min(currentGoal.progress(for: healthSummary), 1)
	}
	
	var goalCompletionPercentage: String {
		return String(format: "%.2f", progress * 100)
	}
	
}

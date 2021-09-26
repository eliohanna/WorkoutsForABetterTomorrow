//
//  GoalViewModel.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 26/09/2021.
//

import UIKit

struct GoalViewModel {
	var goal: Goal
	var currentHealthSummary: GoalsListHealthSummary
	
	var progress: Double {
		return goal.progress(for: currentHealthSummary)
	}
}

extension GoalViewModel: Hashable {
	static func == (lhs: GoalViewModel, rhs: GoalViewModel) -> Bool {
		return lhs.goal == rhs.goal &&
			lhs.currentHealthSummary == rhs.currentHealthSummary
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(goal.id)
	}
}

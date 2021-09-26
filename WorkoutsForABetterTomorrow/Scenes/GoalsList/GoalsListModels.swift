//
//  GoalsListModels.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 25/09/2021.
//

import Foundation
import Combine

enum GoalsListState {
	case unauthorized
	case loading
	case success(goals: [GoalViewModel])
	case noResults
	case failure(Error)
}

struct GoalsListHealthSummary {
	var steps: Double
	var walkingDistance: Double
	var runningDistance: Double
}

extension GoalsListHealthSummary: Equatable {
	static func == (lhs: GoalsListHealthSummary, rhs: GoalsListHealthSummary) -> Bool {
		return lhs.steps == rhs.steps &&
			lhs.walkingDistance == rhs.walkingDistance &&
			lhs.runningDistance == rhs.runningDistance
	}
}

//
//  Goal.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 26/09/2021.
//

import Foundation

struct Goal {
	var id: Int
	var goal: Double
	var description: String
	var title: String
	var type: GoalType
	var reward: GoalReward
}

extension Goal: Hashable {
	static func == (lhs: Goal, rhs: Goal) -> Bool {
		return lhs.id == rhs.id
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}

extension Goal {
	static func from(goalResponse: [GoalModel]) -> [Goal] {
		return goalResponse.compactMap({
			guard let goalType = GoalType(rawValue: $0.type.rawValue),
				  let goal = Double($0.goal),
				  let rewardPoints = Double($0.reward.points),
				  let goalTrophy = GoalTrophy(rawValue: $0.reward.trophy.rawValue) else { return nil }
			return .init(id: $0.id,
						 goal: goal,
						 description: $0.description,
						 title: $0.title,
						 type: goalType,
						 reward: .init(trophy: goalTrophy,
									   points: rewardPoints))
		})
	}
	
	func progress(for summary: GoalsListHealthSummary) -> Double {
		var currentCount: Double {
			switch type {
			case .step:
				return summary.steps
			case .walkingDistance:
				return summary.walkingDistance
			case .runningDistance:
				return summary.runningDistance
			}
		}
		
		return currentCount/goal
	}
}

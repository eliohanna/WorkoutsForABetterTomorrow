//
//  GoalDecoder.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 27/09/2021.
//

import Foundation

/// Responsible to decode a `GoalEntity` CoreData Entity into a `Goal`
class GoalDecoder {
	func decode(goalEntity: GoalEntity) -> Goal? {
		guard let description = goalEntity.subtitle,
			  let title = goalEntity.title,
			  let type = GoalType(rawValue: goalEntity.type ?? ""),
			  let reward = goalEntity.reward?.toGoalReward() else { return nil }
		
		return .init(id: Int(goalEntity.id),
					 goal: goalEntity.goal,
					 description: description,
					 title: title,
					 type: type,
					 reward: reward)
	}
}

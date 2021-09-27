//
//  GoalEncoder.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 27/09/2021.
//

import Foundation

/// Responsible to encode a `Goal` into CoreData Entity `GoalEntity`
class GoalEncoder {
	@discardableResult
	func encode(goal: Goal, into goalEntity: GoalEntity) -> GoalEntity {
		guard let goalContext = goalEntity.managedObjectContext else {
			assertionFailure("GoalEntity should have a context!")
			return goalEntity
		}
		goalEntity.goal = goal.goal
		goalEntity.id = Int32(goal.id)
		goalEntity.subtitle = goal.description
		goalEntity.title = goal.title
		goalEntity.type = goal.type.rawValue
		goalEntity.reward = RewardEncoder().encode(reward: goal.reward, into: RewardEntity(context: goalContext))
		return goalEntity
	}
}

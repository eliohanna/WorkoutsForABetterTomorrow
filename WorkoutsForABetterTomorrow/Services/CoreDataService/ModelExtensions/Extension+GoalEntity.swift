//
//  Extension+GoalEntity.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 26/09/2021.
//

import Foundation
import CoreData

extension GoalEntity {
	convenience init(context: NSManagedObjectContext, goal: Goal) {
		self.init(context: context)
		
		self.goal = goal.goal
		self.id = Int32(goal.id)
		self.subtitle = goal.description
		self.title = goal.title
		self.type = goal.type.rawValue
		self.reward = RewardEntity(context: context, reward: goal.reward)
	}
	
	func toGoal() -> Goal? {
		guard let description = subtitle,
			  let title = title,
			  let type = GoalType(rawValue: type ?? ""),
			  let reward = reward?.toGoalReward() else { return nil }
		
		return .init(id: Int(id),
					 goal: goal,
						description: description,
						title: title,
						type: type,
						reward: reward)
	}
}

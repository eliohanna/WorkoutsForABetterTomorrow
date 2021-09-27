//
//  Extension+RewardEntity.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 26/09/2021.
//

import Foundation
import CoreData

extension RewardEntity {
	convenience init(context: NSManagedObjectContext, reward: GoalReward) {
		self.init(context: context)
		RewardEncoder().encode(reward: reward, into: self)
	}
	
	func toGoalReward() -> GoalReward? {
		return RewardDecoder().decode(rewardEntity: self)
	}
}

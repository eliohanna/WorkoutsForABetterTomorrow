//
//  RewardEncoder.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 27/09/2021.
//

import Foundation

/// Responsible to encode a `GoalReward` into CoreData Entity `RewardEntity`
class RewardEncoder {
	@discardableResult
	func encode(reward: GoalReward, into rewardEntity: RewardEntity) -> RewardEntity {
		rewardEntity.points = Int32(reward.points)
		rewardEntity.trophy = reward.trophy.rawValue
		return rewardEntity
	}
}

//
//  RewardDecoder.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 27/09/2021.
//

import Foundation

/// Responsible to decode a `RewardEntity` CoreData Entity into a `GoalReward`
class RewardDecoder {
	func decode(rewardEntity: RewardEntity) -> GoalReward? {
		guard let goalTrophy = GoalTrophy(rawValue: rewardEntity.trophy ?? "") else { return nil }
		
		return .init(trophy: goalTrophy,
					 points: Int(rewardEntity.points))
	}
}

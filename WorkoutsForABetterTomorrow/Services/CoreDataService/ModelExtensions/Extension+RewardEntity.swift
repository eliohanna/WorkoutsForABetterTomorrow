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
		
		points = Int32(reward.points)
		trophy = reward.trophy.rawValue
	}
	
	func toGoalReward() -> GoalReward? {
		guard let goalTrophy = GoalTrophy(rawValue: trophy ?? "") else { return nil }
		
		return .init(trophy: goalTrophy,
					 points: Int(points))
	}
}

//
//  GoalModel.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 26/09/2021.
//

import Foundation

struct GoalModel: Codable {
	var id: Int
	var goal: String
	var description: String
	var title: String
	var type: GoalTypeModel
	var reward: GoalRewardModel
}

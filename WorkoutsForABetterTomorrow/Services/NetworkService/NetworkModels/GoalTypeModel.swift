//
//  GoalTypeModel.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 26/09/2021.
//

import Foundation

enum GoalTypeModel: String, Codable {
	case step
	case walkingDistance = "walking_distance"
	case runningDistance = "running_distance"
}

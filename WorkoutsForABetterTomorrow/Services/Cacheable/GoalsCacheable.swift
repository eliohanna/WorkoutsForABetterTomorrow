//
//  GoalsCacheable.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 26/09/2021.
//

import Foundation

protocol GoalsCacheable {
	func save(goals: [GoalModel])
	func get() -> [Goal]?
}

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
		GoalEncoder().encode(goal: goal, into: self)
	}
	
	func toGoal() -> Goal? {
		return GoalDecoder().decode(goalEntity: self)
	}
}

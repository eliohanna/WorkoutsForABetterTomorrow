//
//  CacheableGoalsUseCase.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 26/09/2021.
//

import Foundation
import CoreData

protocol CacheableGoalsUseCase {
	func save(goals: [Goal])
	func get() -> [Goal]?
}

/// This class was created to abstract the saving, and loading of the goals in CoreData
class DefaultCacheableGoalsUseCase {
	private let coreDataService: CoreDataService
	
	init(coreDataService: CoreDataService) {
		self.coreDataService = coreDataService
	}

	private func deleteAllGoals() {
		coreDataService.deleteRecords(for: GoalEntity.self)
	}
}

extension DefaultCacheableGoalsUseCase: CacheableGoalsUseCase {
	func save(goals: [Goal]) {
		deleteAllGoals()
		let context = coreDataService.persistentContainer.viewContext
		let _ = goals.map({ GoalEntity(context: context, goal: $0) })
		
		coreDataService.saveContext()
	}
	
	func get() -> [Goal]? {
		let sortDescriptor = NSSortDescriptor(keyPath: \GoalEntity.id, ascending: true)
		let entities = coreDataService.fetchRecords(for: GoalEntity.self, sortDescriptors: [sortDescriptor])
		return entities?.map({ $0.toGoal() }).compactMap({ $0 })
	}
}

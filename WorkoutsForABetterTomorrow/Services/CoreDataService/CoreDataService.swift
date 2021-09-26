//
//  CoreDataService.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 26/09/2021.
//

import Foundation
import CoreData

class CoreDataService {
	var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "WorkoutsForABetterTomorrow")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	private var context: NSManagedObjectContext { persistentContainer.viewContext }
	
	func saveContext() {
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				let nserror = error as NSError
				assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
	func deleteRecords(for entityType: NSManagedObject.Type) {
		guard let records = fetchRecords(for: entityType) else { return }
		records.forEach({ context.delete($0) })
		saveContext()
	}
	
	func fetchRecords<T: NSManagedObject>(for entityType: T.Type, sortDescriptors: [NSSortDescriptor]? = nil) -> [T]? {
		let fetchRequest = entityType.fetchRequest()
		if let sortDescriptors = sortDescriptors {
			fetchRequest.sortDescriptors = sortDescriptors
		}
		guard let fetchResults = try? context.fetch(fetchRequest) else { return nil }
		return fetchResults.map({ $0 as? T }).compactMap({ $0 })
	}
}

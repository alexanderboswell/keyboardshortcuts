//
//  DataController.swift
//  keyboardshortcuts
//
//  Created by Alexander Boswell on 8/15/22.
//

import CoreData
import Foundation

class DataController: ObservableObject {
	let container = NSPersistentContainer(name:"keyboardshortcuts")
	
	init(inMemory: Bool = false) {
		if inMemory {
			container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
		}
		container.loadPersistentStores { description, error in
			if let error = error {
				print("Core data failed to load: \(error.localizedDescription)")
			}
		}
	}
	
	static var preview: DataController = {
		let result = DataController(inMemory: true)
		let viewContext = result.container.viewContext
		for index in 0..<10 {
			let newShortcut = KeyboardShortcut(context: viewContext)
			newShortcut.details = "My shortcut \(index)"
			newShortcut.id = UUID()
			newShortcut.application = "testApp"
			newShortcut.shortcut = "CMD + D"
		}
		do {
			try viewContext.save()
		} catch {
			// Replace this implementation with code to handle the error appropriately.
			// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			let nsError = error as NSError
			fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
		}
		return result
	}()
}

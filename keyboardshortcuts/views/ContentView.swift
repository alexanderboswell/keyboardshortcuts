//
//  ContentView.swift
//  keyboardShortcuts
//
//  Created by Alexander Boswell on 9/19/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
	
	@StateObject private var dataController = DataController()
	
	var body: some View {
			InternalContentView()
				.environment(\.managedObjectContext, dataController.container.viewContext)
		.padding()
	}
}

fileprivate struct InternalContentView: View {
	@Environment(\.managedObjectContext) private var viewContext

	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \KeyboardShortcut.application, ascending: true)],
		animation: .default)
	private var shortcuts: FetchedResults<KeyboardShortcut>
	
	@State private var isPresentingAddView = false
	@State private var selectedKeyboardShortcut: KeyboardShortcut.ID? = nil
	@State private var searchText = ""
	
	private var searchResults: [KeyboardShortcut] {
		if searchText.isEmpty {
			return shortcuts.filter { _ in true }
		} else {
			return shortcuts.filter { shortcut in
				let details = shortcut.details!.lowercased()
				let application = shortcut.application!.lowercased()
//				let shortcut = shortcut.shortcut!
				let matchingText = searchText.lowercased()
				return details.contains(matchingText) || application.contains(matchingText)
			}
		}
	}


	var body: some View {
		VStack {
			HStack {
				TextField(text: $searchText, prompt: Text("Search")) {}
				Button {
					if let keyboardShortcut = selectedKeyboardShortcut, let id = keyboardShortcut , let index = shortcuts.firstIndex(where: { shortcut in
						shortcut.id == id
					}) {
						deleteItem(index: index)
						selectedKeyboardShortcut = nil
					}
				} label: {
					Image(systemName: "minus")
				}
				.disabled(selectedKeyboardShortcut == nil)
				Button {
					isPresentingAddView = true
				} label: {
					Image(systemName: "plus")
				}
				.popover(isPresented: $isPresentingAddView, attachmentAnchor: .point(.trailing), arrowEdge: .trailing) {
					NewShortcutView()
						.frame(width: 350, height: 150)
				}
			}	
			Table(searchResults, selection: $selectedKeyboardShortcut) {
					TableColumn("Details", value: \.details!)
					.width(160)
					TableColumn("Shorcut", value: \.shortcut!)
					.width(75)
					TableColumn("Application", value: \.application!)
					.width(65)
				}
			.searchable(text: $searchText, prompt: "Search")
		}
		.padding(0)
	}

	private func addItem() {
		withAnimation {
			let newShortcut = KeyboardShortcut(context: viewContext)
			newShortcut.details = "Does this work! + \(RAND_MAX / 5)"
			newShortcut.shortcut = "⌘ + 5 + E"
			newShortcut.id = UUID()
			newShortcut.application = "onenote"

			do {
				try viewContext.save()
			} catch {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				let nsError = error as NSError
				fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
			}
		}
	}

	private func deleteItem(index: Int) {
		if shortcuts.count > 0 {
			let offsets: IndexSet = IndexSet(integer: index)
			withAnimation {
				offsets.map { shortcuts[$0] }.forEach(viewContext.delete)

				do {
					try viewContext.save()
				} catch {
					// Replace this implementation with code to handle the error appropriately.
					// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
					let nsError = error as NSError
					fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
				}
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView().environment(\.managedObjectContext, DataController.preview.container.viewContext)
	}
}

//
//  ContentView.swift
//  keyboardShortcuts
//
//  Created by Alexander Boswell on 9/19/22.
//

import SwiftUI
import CoreData
import SwiftData

struct ContentView: View {
	var sharedModelContainer: ModelContainer = {
		let schema = Schema([
			KeyboardShortcut.self,
		])
		let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
		
		do {
			return try ModelContainer(for: schema, configurations: [modelConfiguration])
		} catch {
			fatalError("Could not create ModelContainer: \(error)")
		}
	}()
	
	var body: some View {
			InternalContentView()
			.modelContainer(sharedModelContainer)
		.padding()
	}
}

fileprivate struct InternalContentView: View {
	@Environment(\.modelContext) private var modelContext
	@Query private var shortcuts: [KeyboardShortcut]
	
	@State private var isPresentingAddView = false
	@State private var selectedKeyboardShortcut: UUID? = nil
	@State private var searchText = ""
	
	private var searchResults: [KeyboardShortcut] {
		if searchText.isEmpty {
			return shortcuts.filter { _ in true }
		} else {
			return shortcuts.filter { shortcut in
				let details = shortcut.details.lowercased()
				let application = shortcut.application.lowercased()
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
					addItem()
				} label: {
					Text("adding a shortcut")
				}

				Button {
					if let keyboardShortcut = selectedKeyboardShortcut, let index = shortcuts.firstIndex(where: { shortcut in
						shortcut.id == keyboardShortcut
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
						.frame(minWidth: 350, minHeight: 150)
				}
			}	
			Table(searchResults, selection: $selectedKeyboardShortcut) {
					TableColumn("Details", value: \.details)
					.width(160)
					TableColumn("Shorcut", value: \.shortcut)
					.width(75)
					TableColumn("Application", value: \.application)
					.width(65)
				}
			.searchable(text: $searchText, prompt: "Search")
		}
		.padding(0)
	}

	private func addItem() {
		withAnimation {
			let newShortcut = KeyboardShortcut(application: "one note", details: "Does this work! + \(RAND_MAX / 5)", shortcut: "⌘ + 5 + E")
			modelContext.insert(newShortcut)
		}
	}

	private func deleteItem(index: Int) {
		withAnimation {
			modelContext.delete(shortcuts[index])
		}
	}
}

#Preview {
	InternalContentView()
		.modelContainer(for: KeyboardShortcut.self, inMemory: true)
}


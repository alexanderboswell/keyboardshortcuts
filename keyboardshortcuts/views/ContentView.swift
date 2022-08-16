//
//  ContentView.swift
//  keyboardshortcuts
//
//  Created by Alexander Boswell on 8/5/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \KeyboardShortcut.application, ascending: true)],
        animation: .default)
    private var shortcuts: FetchedResults<KeyboardShortcut>
	
	@State private var isPresentingAddView = false
	@State private var selectedKeyboardShortcut: KeyboardShortcut.ID? = nil

    var body: some View {
		Table(shortcuts, selection: $selectedKeyboardShortcut) {
				TableColumn("Description", value: \.shortcutDescription!)
				TableColumn("Shorcut", value: \.shortcut!)
				TableColumn("Application", value: \.application!)
			}
            .toolbar {
                ToolbarItem {
                    Button(action:  {
						// TODO: remove, just for testing
						// addItem()
						isPresentingAddView = true
					}) {
                        Label("Add Item", systemImage: "plus")
                    }
					.popover(isPresented: $isPresentingAddView, attachmentAnchor: .point(.bottom), arrowEdge: .bottom) {
						NewShortcutView()
							.frame(width: 500, height: 200)
					}
					
				}
				ToolbarItem {
					Button(action: {
						if let keyboardShortcut = selectedKeyboardShortcut, let id = keyboardShortcut , let index = shortcuts.firstIndex(where: { shortcut in
							shortcut.id == id
						}) {
							deleteItem(index: index)
						}
					}) {
						Label("Delete Item", systemImage: "minus")
					}
                }
            }
    }

    private func addItem() {
        withAnimation {
            let newShortcut = KeyboardShortcut(context: viewContext)
            newShortcut.shortcutDescription = "my new shortcut! + \(RAND_MAX / 5)"
			newShortcut.shortcut = "⌘ + 5 + E"
			newShortcut.id = UUID()
			newShortcut.application = "a xcode"

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

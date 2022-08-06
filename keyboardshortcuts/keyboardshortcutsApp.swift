//
//  keyboardshortcutsApp.swift
//  keyboardshortcuts
//
//  Created by Alexander Boswell on 8/5/22.
//

import SwiftUI

@main
struct keyboardshortcutsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

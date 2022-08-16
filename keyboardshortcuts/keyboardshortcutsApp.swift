//
//  keyboardshortcutsApp.swift
//  keyboardshortcuts
//
//  Created by Alexander Boswell on 8/5/22.
//

import SwiftUI

@main
struct keyboardshortcutsApp: App {
	
	@StateObject private var dataController = DataController()
	
	@NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	init() {
	  AppDelegate.shared = self.appDelegate
	}
	
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
				.frame(width: 600, height: 450)
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
	var statusBarItem: NSStatusItem?
	static var shared : AppDelegate!
	func applicationDidFinishLaunching(_ notification: Notification) {
		// Set the SwiftUI's ContentView to the Popover's ContentViewController
		statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
		statusBarItem?.button?.image = NSImage(named: "Image")
//		setupMenu()
	}
	
	func setupMenu() {
		   let menu = NSMenu()
		   let openMenuItem = NSMenuItem(title: "Shortcuts", action: nil , keyEquivalent: "1")
		   menu.addItem(openMenuItem)
		
		let addShortcutMenuItem = NSMenuItem(title: "Add", action: nil , keyEquivalent: "2")
		menu.addItem(addShortcutMenuItem)
		
		let searchShortcutsMenuItem = NSMenuItem(title: "Search", action: nil , keyEquivalent: "2")
		menu.addItem(searchShortcutsMenuItem)

		statusBarItem?.menu = menu
	   }
}

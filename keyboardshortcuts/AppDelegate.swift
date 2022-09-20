//
//  AppDelegate.swift
//  keyboardShortcuts
//
//  Created by Alexander Boswell on 9/5/22.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

	private var statusBarItem: NSStatusItem?
	private let popover = NSPopover()

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
		if let button = statusBarItem?.button {
			button.image = NSImage(named: NSImage.Name("StatusBarIcon"))
			button.action = #selector(togglePopover(_:))
		}
//		setupMenu()
		
		popover.contentViewController = ContentViewController.newInstance()
		popover.animates = true
//		popover.contentSize = CGSize(width: 300, height: 300)
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

	func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
		return true
	}


	// MARK: Private methods
	
	@objc func togglePopover(_ sender: NSStatusItem) {
		if self.popover.isShown {
			closePopover(sender: sender)
		}
		else {
			showPopover(sender: sender)
		}
	}
	
	private func setupMenu() {
		   let menu = NSMenu()
		let openMenuItem = NSMenuItem(title: "Shortcuts", action: nil, keyEquivalent: "1")
//		openMenuItem.keyEquivalentModifierMask = [.shift, .command]
		   menu.addItem(openMenuItem)
		openMenuItem.target = self
		
		let addShortcutMenuItem = NSMenuItem(title: "Add", action: nil , keyEquivalent: "2")
		menu.addItem(addShortcutMenuItem)
		
		let searchShortcutsMenuItem = NSMenuItem(title: "Search", action: nil , keyEquivalent: "3")
		menu.addItem(searchShortcutsMenuItem)

		statusBarItem?.menu = menu
	   }
	
	private func showPopover(sender: Any?) {
		if let button = statusBarItem?.button {
			self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
		}
	}

	private func closePopover(sender: Any?)  {
		self.popover.performClose(sender)
	}
}


//
//  KeyboardShortcut.swift
//  keyboardShortcuts
//
//  Created by Alexander Boswell on 1/3/24.
//

import Foundation
import SwiftData

@Model
final class KeyboardShortcut {
	var application: String
	var details: String
	let id = UUID()
	var shortcut: String
	
	init(application: String, details: String, shortcut: String) {
		self.application = application
		self.details = details
		self.shortcut = shortcut
	}
}

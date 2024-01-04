//
//  NewShortcutView.swift
//  keyboardshortcuts
//
//  Created by Alexander Boswell on 8/15/22.
//

import SwiftUI
import Combine

struct MyTextField: NSViewRepresentable {
	@Binding var text: String
	
	func makeNSView(context: Context) -> NSTextField {
		let textField = NSTextField()
		textField.delegate = context.coordinator
		textField.stringValue = text
		return textField
	}
	
	func updateNSView(_ nsView: NSTextField, context: Context) {
		nsView.stringValue = text
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	class Coordinator: NSObject, NSTextFieldDelegate {
		var parent: MyTextField
		
		init(_ parent: MyTextField) {
			self.parent = parent
		}
		
		func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
			if commandSelector == #selector(NSResponder.insertNewline(_:)) {
				// Handle return key
				return true
			} else if commandSelector == #selector(NSResponder.insertTab(_:)) {
				// Handle tab key
				return true
			} else if commandSelector == #selector(NSResponder.insertBacktab(_:)) {
				// Handle shift + tab key
				return true
			} else if commandSelector == #selector(NSResponder.insertText(_:)) {
				if let event = NSApplication.shared.currentEvent {
					if event.modifierFlags.contains(.control) {
						// Handle control + key down
						return true
					}
				}
			}
			return false
		}
	}
}


struct NewShortcutView: View {
	@Environment(\.modelContext) private var modelContext
	@Environment(\.presentationMode) private var presentationMode
	
	@State private var details: String = ""
	@State private var application: String = ""
	@State private var shortcut: String = ""
	@FocusState private var focusedField: Field?
	
	var body: some View {
		Form {
			MyTextField(text: $shortcut)
//			TextField("Shortcut", text: $shortcut)
//				.lineLimit(1)
			VStack {
				ForEach(specialSymbols, id: \.id) { specialSymbol in
					Button(specialSymbol.title) {
						appendToShortcut(specialSymbol.symbol)
					}
				}
			}
			TextField("Details", text: $details)
				.lineLimit(nil)
			TextField("Application", text: $application)
				.lineLimit(1)
			HStack {
				Spacer()
				Button("Add") {
					saveKeyboardShortcut()
				}
				.disabled(disableAdd)
			}
//			.padding([.top, .bottom])
		}
		.textFieldStyle(.roundedBorder)
		.padding()
	}
	
	private var disableAdd: Bool {
		return details == "" || application == "" || shortcut == ""
	}
	
	private func appendToShortcut(_ value: String) {
		appendAddSymbol()
		shortcut.append(contentsOf: value)
	}
	
	private func appendAddSymbol() {
		if shortcut.last != "+" && !shortcut.isEmpty {
			shortcut.append(contentsOf: "+")
		}
	}
	
	private func saveKeyboardShortcut() {
		let keyboardShortcut = KeyboardShortcut(
			application: application,
			details: details,
			shortcut: shortcut)
		withAnimation {
			modelContext.insert(keyboardShortcut)
		}

		presentationMode.wrappedValue.dismiss()
	}
}

fileprivate struct SpecialSymbol {
	let title: String
	let symbol: String
	let id: UUID
	
	init(title: String, symbol: String) {
		self.title = title
		self.symbol = symbol
		id = UUID()
	}
}

fileprivate let specialSymbols: [SpecialSymbol] = [
	SpecialSymbol(title: "Cmd ⌘", symbol: "⌘"),
	SpecialSymbol(title: "Shift ⇧", symbol: "⇧"),
	SpecialSymbol(title: "Option ⌥", symbol: "⌥"),
	SpecialSymbol(title: "Crtl ⌃", symbol: "⌃"),
	SpecialSymbol(title: "Caps Lock ⇪", symbol: "⇪")
]
	

struct NewShortcutView_Previews: PreviewProvider {
	static var previews: some View {
		NewShortcutView()
	}
}


extension NewShortcutView {
	func keyboardUpDownSubscribe() {
		NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (aEvent) -> NSEvent? in
			print(aEvent.keyCode)
			
			guard focusedField != nil else { return nil }
			
			guard aEvent.specialKey != nil else { return aEvent }
			
			switch aEvent.specialKey! {
			case .downArrow:
				focusNextField()
			case .upArrow:
				focusPreviousField()
			default:
				break
			}
			
			return aEvent
		}
	}
	
	private enum Field: Int, CaseIterable {
		case f1, f2, f3, f4
	}
	
	private func focusPreviousField() {
		focusedField = focusedField.map {
			Field(rawValue: $0.rawValue - 1) ?? Field.allCases.first!
		}
	}
	
	private func focusNextField() {
		focusedField = focusedField.map {
			Field(rawValue: $0.rawValue + 1) ?? Field.allCases.last!
		}
	}
}

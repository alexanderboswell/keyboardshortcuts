//
//  NewShortcutView.swift
//  keyboardshortcuts
//
//  Created by Alexander Boswell on 8/15/22.
//

import SwiftUI




struct NewShortcutView: View {
	@Environment(\.managedObjectContext) private var viewContext
	@Environment(\.presentationMode) private var presentationMode
	
	@State private var shortcutDescription: String = ""
	@State private var application: String = ""
	@State private var shortcut: String = ""
	
    var body: some View {
		Form {
			TextField("Description", text: $shortcutDescription)
			TextField("Application", text: $application)
			TextField("Shortcut", text: $shortcut)
				.onSubmit {
					
				}
			HStack {
				ForEach(specialSymbols, id: \.id) { specialSymbol in
					Button(specialSymbol.title) {
						appendToShortcut(specialSymbol.symbol)
					}
				}
			}
			HStack {
				Spacer()
				Button("Add") {
					saveKeyboardShortcut()
				}
				.disabled(disableAdd)
			}
			.padding([.top, .bottom])
		}
		.onChange(of: shortcut, perform: { newValue in
		})
		.padding()
    }
	
	private var disableAdd: Bool {
		return shortcutDescription == "" || application == "" || shortcut == ""
	}
	
	private func appendToShortcut(_ value: String) {
//		appendAddSymbol()
		shortcut.append(contentsOf: value)
	}
	
	private func appendAddSymbol() {
		if shortcut.last != "+" && !shortcut.isEmpty {
			shortcut.append(contentsOf: "+")
		}
	}
	
	private func saveKeyboardShortcut() {
		let keyboardShortcut = KeyboardShortcut(context: viewContext)
		keyboardShortcut.id = UUID()
		keyboardShortcut.shortcutDescription = shortcutDescription
		keyboardShortcut.application = application
		keyboardShortcut.shortcut = shortcut
		
		try? viewContext.save()
		
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
        NewShortcutView().environment(\.managedObjectContext, DataController.preview.container.viewContext)
    }
}

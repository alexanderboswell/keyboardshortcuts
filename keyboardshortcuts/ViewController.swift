//
//  ViewController.swift
//  keyboardShortcuts
//
//  Created by Alexander Boswell on 9/5/22.
//

import Cocoa
import SwiftUI

class ContentViewController: NSViewController {
	
	override func loadView() {
		super.loadView()
		let hostingView = NSHostingView(rootView: ContentView())
		view.addSubview(hostingView)
		hostingView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			hostingView.topAnchor.constraint(equalTo: view.topAnchor),
			hostingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			hostingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			hostingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			view.widthAnchor.constraint(equalToConstant: 400),
			view.heightAnchor.constraint(equalToConstant: 300)
		])
	}

	override func viewDidLoad() {
		super.viewDidLoad()


	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	static func newInstance() -> ContentViewController {
		let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
		let identifier = NSStoryboard.SceneIdentifier("ViewController")
		  
		guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? ContentViewController else {
			fatalError("Unable to instantiate ViewController in Main.storyboard")
		}
		return viewcontroller
	}
}



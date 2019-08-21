//
//  SingleViewController.swift
//  ContextMenu
//
//  Created by Kyle Bashour on 8/20/19.
//  Copyright © 2019 Kyle Bashour. All rights reserved.
//

import UIKit

/*

 This view controller displays a square. Long-pressing the square will open a context menu for that view.

 */

class SingleViewController: UIViewController, ContextMenuDemo {

    // MARK: ContextMenuDemo

    static var title: String { return "Single View" }

    // MARK: SingleViewController

    private let menuView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Self.title
        view.backgroundColor = .systemBackground

        menuView.backgroundColor = .systemBlue
        menuView.frame.size = .init(width: 100, height: 100)
        view.addSubview(menuView)

        /*

         Here we create an interaction, give it a delegate, and
         add it to a view. This tells UIKit to call the delegate
         methods when the view is long-press or 3D touched, and
         display a menu if the delegate returns one.

         */

        let interaction = UIContextMenuInteraction(delegate: self)
        menuView.addInteraction(interaction)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuView.center = view.center
    }
}

extension SingleViewController: UIContextMenuInteractionDelegate {

    /*

     This is where you create and return a menu. This demo
     just uses a simple menu with three actions - check out
     `makeDefaultDemoMenu` to see how it's created.

     */

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            return self.makeDefaultDemoMenu()
        }
    }
}

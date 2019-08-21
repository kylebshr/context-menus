//
//  InlineSubmenuViewController.swift
//  ContextMenu
//
//  Created by Kyle Bashour on 8/20/19.
//  Copyright © 2019 Kyle Bashour. All rights reserved.
//

import UIKit

/*

 This view controller displays a square that can open a menu, and the menu has a sub-menu shown inline with a separator.

 ---------------------
 | Share             |
 ---------------------
 ---------------------
 | Rename            |
 ---------------------
 | Delete            |
 ---------------------

 */

class InlineSubmenuViewController: UIViewController, ContextMenuDemo {

    // MARK: ContextMenuDemo

    static var title: String { return "Inline Submenu (Separators)" }

    // MARK: InlineSubmenuViewController

    private let menuView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Self.title
        view.backgroundColor = .systemBackground

        menuView.backgroundColor = .systemBlue
        menuView.frame.size = .init(width: 100, height: 100)
        view.addSubview(menuView)

        let interaction = UIContextMenuInteraction(delegate: self)
        menuView.addInteraction(interaction)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuView.center = view.center
    }
}

extension InlineSubmenuViewController: UIContextMenuInteractionDelegate {

    /*

     When we create our menu, we'll use the exact same items
     as the basic menu, but group "rename" and "delete" into
     a sub-menu titled "Edit..."

     We'll also specify the `displayInline` option to show it at
     the top level with a separator.

     */

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in

            let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in }
            let rename = UIAction(title: "Rename", image: UIImage(systemName: "square.and.pencil")) { action in }
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in }

            // The edit sub-menu is created like the top-level menu, but we also specify it should be inline...
            let edit = UIMenu(title: "Edit...", options: .displayInline, children: [rename, delete])

            // ...then we add it as a child as if it were an action.
            return UIMenu(title: "", children: [share, edit])
        }
    }
}

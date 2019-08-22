//
//  SubmenuViewController.swift
//  ContextMenu
//
//  Created by Kyle Bashour on 8/20/19.
//  Copyright © 2019 Kyle Bashour. All rights reserved.
//

import UIKit

/*

 This view controller displays a square that can open a menu, and the menu has an "Edit" submenu. When "Edit" is tapped,
 the submenu is opened and displays rename/delete options. "Delete" is itself a submenu, allowing the user to confirm
 (always a good idea for destructive actions).

 ---------------------
 | Share             |
 ---------------------
 | Edit...           |
 ---------------------

 User taps edit, and the menu transforms:

 ---------------------
 | Rename            |
 ---------------------
 | Delete            |
 ---------------------

 User taps delete, and the menu transforms again:

 ---------------------
 | Cancel            |
 ---------------------
 | Delete            |
 ---------------------

 */

class SubmenuViewController: UIViewController, ContextMenuDemo {

    // MARK: ContextMenuDemo

    static var title: String { return "Submenu" }

    // MARK: SubmenuViewController

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

extension SubmenuViewController: UIContextMenuInteractionDelegate {

    /*

     When we create our menu, we'll use the exact same items
     as the basic menu, but group "rename" and "delete" into
     a submenu titled "Edit..."

     */

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in

            let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in }
            let rename = UIAction(title: "Rename", image: UIImage(systemName: "square.and.pencil")) { action in }

            let deleteCancel = UIAction(title: "Cancel", image: UIImage(systemName: "xmark")) { action in }
            let deleteConfirmation = UIAction(title: "Delete", image: UIImage(systemName: "checkmark"), attributes: .destructive) { action in }

            // The delete sub-menu is created like the top-level menu, but we also specify an image and options
            let delete = UIMenu(title: "Delete", image: UIImage(systemName: "trash"), options: .destructive, children: [deleteCancel, deleteConfirmation])

            // The edit menu adds delete as a child, just like an action...
            let edit = UIMenu(title: "Edit...", children: [rename, delete])

            // ...then we add edit as a child of the main menu.
            return UIMenu(title: "", children: [share, edit])
        }
    }
}

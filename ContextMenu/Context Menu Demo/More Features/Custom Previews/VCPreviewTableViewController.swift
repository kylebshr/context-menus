//
//  VCPreviewTableViewController.swift
//  ContextMenu
//
//  Created by Kyle Bashour on 8/20/19.
//  Copyright © 2019 Kyle Bashour. All rights reserved.
//

import UIKit

/*

 This view controller displays a list of icons with their names, and uses a view controller for the menu preview.
 When the preview is tapped, it pushes that view controller.

 */

/// A basic view controller used for previewing and when an item is selected
private class PreviewViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen

        // The preview will size to the preferredContentSize, which can be useful
        // for displaying a preview with the dimension of an image, for example.
        preferredContentSize = CGSize(width: 300, height: 200)
    }
}

class VCPreviewTableViewController: UITableViewController, ContextMenuDemo {

    // MARK: ContextMenuDemo

    static var title: String { return "UIViewController (Table View)" }

    // MARK: CustomPreviewTableViewController

    private let identifier = "identifier"

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Self.title
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Fixtures.cloudSymbols.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = Fixtures.cloudSymbols[indexPath.row]
        cell.imageView?.image = UIImage(systemName: Fixtures.cloudSymbols[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    // MARK: - UITableViewDelegate

    /*

     The `previewProvider` argument just needs a function
     that returns a view controller. You can do this with a
     closure, or pass in a method that creates the view controller
     (in this case, the preview view controller initializer).

     We can also implement `willPerformPreviewActionForMenuWith`
     to respond to the user tapping on the preview.

     */

    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: PreviewViewController.init) { suggestedActions in
            return self.makeDefaultDemoMenu()
        }
    }

    override func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {

        // If we used a view controller for our preview, we can pull it out of the animator and show it once the commit animation is complete.
        animator.addCompletion {
            if let viewController = animator.previewViewController {
                self.show(viewController, sender: self)
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = PreviewViewController()
        show(viewController, sender: self)
    }
}

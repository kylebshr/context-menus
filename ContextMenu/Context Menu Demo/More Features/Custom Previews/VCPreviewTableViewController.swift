//
//  CustomPreviewTableViewController.swift
//  ContextMenu
//
//  Created by Kyle Bashour on 8/20/19.
//  Copyright © 2019 Kyle Bashour. All rights reserved.
//

import UIKit

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

    private let icons = [
        "cloud",
        "cloud.bolt",
        "cloud.bolt.fill",
        "cloud.bolt.rain",
        "cloud.bolt.rain.fill",
        "cloud.drizzle",
        "cloud.drizzle.fill",
        "cloud.fill",
        "cloud.fog",
        "cloud.fog.fill",
        "cloud.hail",
        "cloud.hail.fill",
        "cloud.heavyrain",
        "cloud.heavyrain.fill",
        "cloud.moon",
        "cloud.moon.bolt",
        "cloud.moon.bolt.fill",
        "cloud.moon.fill",
        "cloud.moon.rain",
        "cloud.moon.rain.fill",
        "cloud.rain",
        "cloud.rain.fill",
        "cloud.sleet",
        "cloud.sleet.fill",
        "cloud.snow",
        "cloud.snow.fill",
        "cloud.sun",
        "cloud.sun.bolt",
        "cloud.sun.bolt.fill",
        "cloud.sun.fill",
        "cloud.sun.rain",
        "cloud.sun.rain.fill",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Self.title
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = icons[indexPath.row]
        cell.imageView?.image = UIImage(systemName: icons[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    // MARK: - UITableViewDelegate

    /*********************************************************

     The `previewProvider` argument just needs a function
     that returns a view controller. You can do this with a
     closure, or pass in a method that creates the view controller
     (in this case, the preview view controller initializer).

     We can also implement `willPerformPreviewActionForMenuWith`
     to respond to the user tapping on the preview.

     *********************************************************/

    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: PreviewViewController.init) { suggestedActions in
            return self.makeDefaultDemoMenu()
        }
    }

    override func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        let viewController = PreviewViewController()
        show(viewController, sender: self)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = PreviewViewController()
        show(viewController, sender: self)
    }
}

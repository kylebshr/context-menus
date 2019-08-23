//
//  TargetedPreviewTableViewController.swift
//  ContextMenu
//
//  Created by Kyle Bashour on 8/20/19.
//  Copyright © 2019 Kyle Bashour. All rights reserved.
//

import UIKit

/*

 This view controller displays a list of icons with their names, and has a custom preview of the icon when
 the menu is opened. The preview is a custom view, and has a custom shape applied instead of the default rounded rect.
 When the preview is tapped, it pushes a view controller that displays the icon.

 */


/// A custom view for the menu preview
private class PreviewView: UIView {
    private static let size = CGSize(width: 40, height: 40)

    private let imageView = UIImageView()

    init(systemImageName: String) {
        super.init(frame: .init(origin: .zero, size: Self.size))

        backgroundColor = .systemBlue

        imageView.image = UIImage(systemName: systemImageName)
        imageView.tintColor = .white
        imageView.contentMode = .center
        imageView.frame = bounds
        addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// A view controller that previews a single icon
private class IconPreviewViewController: UIViewController {
    private let imageView = UIImageView()

    init(systemImageName: String) {
        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = .secondarySystemBackground
        navigationItem.title = systemImageName

        imageView.image = UIImage(systemName: systemImageName)
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TargetedPreviewTableViewController: UITableViewController, ContextMenuDemo {

    // MARK: ContextMenuDemo

    static var title: String { return "UITargetedPreview (Table View)" }

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

     When creating our configuration, we'll specify an
     identifier so that we can tell which item is being
     previewed in
     `previewForHighlightingContextMenuWithConfiguration`.

     It's best not to pass the index path as your identifier,
     as the table view data could change while a menu is open.
     Passing the id of the model is a good idea.

     We'll also implement `willPerformPreviewActionForMenuWith`
     to respond to the user tapping on the preview.

     */

    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        // We have to create an NSString since the identifier must conform to NSCopying
        let identifier = NSString(string: Fixtures.cloudSymbols[indexPath.row])

        // Create our configuration with an indentifier
        return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { suggestedActions in
            return self.makeDefaultDemoMenu()
        }
    }

    override func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {

        // Ensure we can get the expected identifier
        guard let identifier = configuration.identifier as? String else { return nil }

        // Get the current index of the model
        guard let row = Fixtures.cloudSymbols.firstIndex(of: identifier) else { return nil }

        // Get the cell from the table view to contain our preview
        guard let cell = tableView.cellForRow(at: .init(row: row, section: 0)) else { return nil }

        // Create a view for previewing
        let preview = PreviewView(systemImageName: identifier)

        // Rather than rounding our preview view, we should specify custom shapes for our preview in the parameters
        let parameters = UIPreviewParameters()
        parameters.visiblePath = UIBezierPath(roundedRect: preview.frame, cornerRadius: preview.frame.midY)

        // Create a target with a center at the image view center
        let target = UIPreviewTarget(container: cell, center: cell.imageView?.center ?? .zero)

        // Return the custom targeted preview
        return UITargetedPreview(view: preview, parameters: parameters, target: target)
    }

    override func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {

        animator.addCompletion {

            // Ensure we can get the expected identifier and create an image
            guard let identifier = configuration.identifier as? String else { return }

            // Create and push the appropiate view controller
            let viewController = IconPreviewViewController(systemImageName: identifier)
            self.show(viewController, sender: self)

        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = IconPreviewViewController(systemImageName: Fixtures.cloudSymbols[indexPath.row])
        show(viewController, sender: self)
    }
}

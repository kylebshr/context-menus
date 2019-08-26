//
//  TargetedPreviewViewController.swift
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


/// A UITableViewCell for displaying an SF Symbol and its name
private class IconPreviewCell: UITableViewCell {
    let previewView = UIView()

    private let iconView = UIImageView()
    private let label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        iconView.tintColor = .white
        iconView.contentMode = .center
        iconView.translatesAutoresizingMaskIntoConstraints = false
        previewView.addSubview(iconView)

        previewView.tintColor = .white
        previewView.layer.cornerRadius = 20
        previewView.backgroundColor = .systemBlue
        previewView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(previewView)

        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)

        // Fix for a long-standing issue with cells breaking constraints
        let bottomAnchor = contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: previewView.bottomAnchor, multiplier: 1)
        bottomAnchor.priority = .required - 1

        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: previewView.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: previewView.centerYAnchor),

            previewView.heightAnchor.constraint(equalToConstant: 40),
            previewView.widthAnchor.constraint(equalToConstant: 40),
            previewView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            previewView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            bottomAnchor,

            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalToSystemSpacingAfter: previewView.trailingAnchor, multiplier: 1),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: label.trailingAnchor, multiplier: 1),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func display(systemImageName: String) {
        label.text = systemImageName
        iconView.image = UIImage(systemName: systemImageName)
    }
}

/// A view controller for displaying a single icon
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

class TargetedPreviewViewController: UITableViewController, ContextMenuDemo {

    // MARK: ContextMenuDemo

    static var title: String { return "UITargetedPreview (Existing View)" }

    // MARK: CustomPreviewTableViewController

    private let identifier = "identifier"

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Self.title
        tableView.register(IconPreviewCell.self, forCellReuseIdentifier: identifier)
    }

    // Since we need to create the same preview for highlighting and dismissing, we'll put it in a utility method
    private func makeTargetedPreview(for configuration: UIContextMenuConfiguration) -> UITargetedPreview? {

        // Ensure we can get the expected identifier
        guard let identifier = configuration.identifier as? String else { return nil }

        // Get the current index of the identifier
        guard let row = Fixtures.cloudSymbols.firstIndex(of: identifier) else { return nil }

        // Get the cell for the index of the model
        guard let cell = tableView.cellForRow(at: .init(row: row, section: 0)) as? IconPreviewCell else { return nil }

        // Since our preview has its own shape (a circle) we need to set the preview parameters
        // backgroundColor to clear, or we'll see a white rect behind it.
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear

        // Return a targeted preview using our cell previewView and parameters
        return UITargetedPreview(view: cell.previewView, parameters: parameters)
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Fixtures.cloudSymbols.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! IconPreviewCell
        cell.display(systemImageName: Fixtures.cloudSymbols[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    // MARK: - UITableViewDelegate

    /*

     When creating our configuration, we'll specify an
     identifier so that we can tell which item is being
     previewed in `previewForHighlightingContextMenuWithConfiguration`
     & `previewForDismissingContextMenuWithConfiguration`.
     Since they create their preview the same way, I've put
     the implementation into a helper method above.

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
        return makeTargetedPreview(for: configuration)
    }

    override func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return makeTargetedPreview(for: configuration)
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

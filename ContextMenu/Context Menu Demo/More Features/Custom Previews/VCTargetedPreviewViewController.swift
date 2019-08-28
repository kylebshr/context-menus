//
//  CustomTargetedPreviewViewController.swift
//  ContextMenu
//
//  Created by Kyle Bashour on 8/20/19.
//  Copyright © 2019 Kyle Bashour. All rights reserved.
//

import UIKit

/*

 This view controller displays a list of icons with their names, and has a custom preview with the icon and
 its name when the menu is opened. It animates the preview in from from the cell image to the center of the view,
 and animates back to the cell image when dismissing.

 */

/// This view controller previews an icon and its name
private class PreviewViewViewController: UIViewController {
    private let imageView = UIImageView()
    private let label = UILabel()

    private lazy var stackView = UIStackView(arrangedSubviews: [imageView, label])

    init(systemImageName: String) {
        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = .secondarySystemBackground

        imageView.image = UIImage(systemName: systemImageName)
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit

        label.text = systemImageName
        label.textColor = .secondaryLabel

        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.layoutMargins = .init(top: 8, left: 16, bottom: 8, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),

            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        preferredContentSize = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VCTargetedPreviewViewController: UITableViewController, ContextMenuDemo {

    // MARK: ContextMenuDemo

    static var title: String { return "UITargetedPreview (Custom Preview)" }

    // MARK: CustomPreviewTableViewController

    private let identifier = "identifier"

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Self.title
        tableView.allowsSelection = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
    }

    private func makeTargetedPreview(for configuration: UIContextMenuConfiguration) -> UITargetedPreview? {

        // Ensure we can get the expected identifier
        guard let identifier = configuration.identifier as? String else { return nil }

        // Get the current index of the model
        guard let row = Fixtures.cloudSymbols.firstIndex(of: identifier) else { return nil }

        // Get the image view in order to create a transform from its frame for our animation
        guard let cellImageView = tableView.cellForRow(at: .init(row: row, section: 0))?.imageView else { return nil }

        // Create a custom shape for our preview, since we want a smaller corner radius than default
        let visiblePath = UIBezierPath(roundedRect: cellImageView.bounds, cornerRadius: 3)

        // Configure our parameters
        let parameters = UIPreviewParameters()
        parameters.visiblePath = visiblePath

        // Return the custom targeted preview
        return UITargetedPreview(view: cellImageView, parameters: parameters)
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Fixtures.cloudSymbols.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = Fixtures.cloudSymbols[indexPath.row]
        cell.imageView?.image = UIImage(systemName: Fixtures.cloudSymbols[indexPath.row])
        cell.imageView?.backgroundColor = .systemBackground
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    // MARK: - UITableViewDelegate

    /*

     In this example, we'll create a targeted preview
     with the cells image view. This tells the system
     to animate to and from the image view instead of
     the cell itself.

     */

    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        // We have to create an NSString since the identifier must conform to NSCopying
        let symbolName = Fixtures.cloudSymbols[indexPath.row]
        let identifier = NSString(string: symbolName)

        // Create our configuration with an indentifier
        return UIContextMenuConfiguration(identifier: identifier, previewProvider: {
            return PreviewViewViewController(systemImageName: symbolName)
        }, actionProvider: { suggestedActions in
            return self.makeDefaultDemoMenu()
        })
    }

    override func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return self.makeTargetedPreview(for: configuration)
    }

    override func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return self.makeTargetedPreview(for: configuration)
    }

    override func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {

        // If we used a view controller for our preview, we can pull it out of the animator and show it once the commit animation is complete.
        animator.addCompletion {
            if let viewController = animator.previewViewController {
                self.show(viewController, sender: self)
            }
        }
    }
}

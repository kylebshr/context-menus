//
//  CustomDismissPreviewViewController.swift
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

/// A custom view for the menu preview
private class PreviewView: UIView {
    private let imageView = UIImageView()
    private let label = UILabel()

    private lazy var stackView = UIStackView(arrangedSubviews: [imageView, label])

    init(systemImageName: String) {
        super.init(frame: .zero)

        backgroundColor = .secondarySystemBackground

        imageView.image = UIImage(systemName: systemImageName)
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
        ])

        label.text = systemImageName
        label.textColor = .secondaryLabel

        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.layoutMargins = .init(top: 8, left: 16, bottom: 8, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        addSubview(stackView)

        frame.size = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        stackView.frame = bounds
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomTargetedPreviewViewController: UITableViewController, ContextMenuDemo {

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

     In this example, we'll create a preview view separate
     from the views already in our cell. We'll apply a custom
     shape and transform in our parameters so that it animates
     from our cell nicely.

     In this case, I think it looks best to have our dismiss
     preview be the cell icon view itself.

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

        // Get the image view in order to create a transform from its frame for our animation
        guard let cellImageView = tableView.cellForRow(at: .init(row: row, section: 0))?.imageView else { return nil }

        // Create a view for previewing
        let preview = PreviewView(systemImageName: identifier)

        // Create a transform for our preview, so it scales from the size of the image view
        let transform = CGAffineTransform(scaleX: cellImageView.bounds.width / preview.bounds.width,
                                          y: cellImageView.bounds.height / preview.bounds.height)

        // Create a preview target with the cell image view as a container. The menu animation will animate
        // the preview from the center and transform given here, to its final position and identity
        // (determined by the system).
        let targetCenter = CGPoint(x: cellImageView.bounds.midX, y: cellImageView.bounds.midY)
        let target = UIPreviewTarget(container: cellImageView, center: targetCenter, transform: transform)

        // Create a custom shape for our preview, since we want a smaller corner radius than default
        let visiblePath = UIBezierPath(roundedRect: preview.bounds, cornerRadius: 4)

        // Configure our parameters
        let parameters = UIPreviewParameters()
        parameters.visiblePath = visiblePath

        // Return the custom targeted preview
        return UITargetedPreview(view: preview, parameters: parameters, target: target)
    }

    override func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {

        // Ensure we can get the expected identifier
        guard let identifier = configuration.identifier as? String else { return nil }

        // Get the current index of the model
        guard let row = Fixtures.cloudSymbols.firstIndex(of: identifier) else { return nil }

        // Get the cell image view to create a target from
        guard let cellImageView = tableView.cellForRow(at: .init(row: row, section: 0))?.imageView else { return nil }

        // Return a target of the cell image view
        return UITargetedPreview(view: cellImageView)
    }

    override func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {

        // Since we're not showing a view controller when the preview is tapped,
        // we set the animator commit style to "dismiss" instead of "pop"
        animator.preferredCommitStyle = .dismiss
    }
}

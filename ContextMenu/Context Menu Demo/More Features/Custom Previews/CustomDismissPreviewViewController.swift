//
//  CustomPreviewTableViewController.swift
//  ContextMenu
//
//  Created by Kyle Bashour on 8/20/19.
//  Copyright © 2019 Kyle Bashour. All rights reserved.
//

import UIKit

/*

 This view controller displays a list of icons with their names, and has a custom preview with the icon and
 its name when the menu is opened. It animates the preview from from the image in the cell, and animates
 back to the cell image when dismissing.

 */

/// A custom view for the menu preview
private class PreviewView: UIView {
    private let imageView = UIImageView()
    private let label = UILabel()

    private lazy var stackView = UIStackView(arrangedSubviews: [imageView, label])

    init(systemImageName: String) {
        super.init(frame: .zero)

        backgroundColor = .systemBlue

        imageView.image = UIImage(systemName: systemImageName)
        imageView.tintColor = .white
        imageView.contentMode = .center

        label.text = systemImageName
        label.textColor = .white

        stackView.spacing = 4
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.layoutMargins = .init(top: 8, left: 8, bottom: 8, right: 8)
        stackView.isLayoutMarginsRelativeArrangement = true
        addSubview(stackView)

        frame.size = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        stackView.frame = bounds
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomDismissPreviewViewController: UITableViewController, ContextMenuDemo {

    // MARK: ContextMenuDemo

    static var title: String { return "UITargetedPreview Custom Dismiss" }

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

     In this example, we use a transform to animate from our
     cell image to the center of the view when previewing.

     By also implementing
     `previewForDismissingContextMenuWithConfiguration`
     the preview will animate back to the image when dismissing.

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

        // Set the position of the preview to the final position so we can compute a transform from the icon
        preview.center = view.center

        // Create a transform from the original icon to our preview
        let sourceRect = cellImageView.convert(cellImageView.bounds, to: view)
        let transform = CGAffineTransform.transformRect(from: preview.frame, toRect: sourceRect)

        // Create a target with a center at the view center, and the transform for the animation.
        // The menu animation will animate the preview from this transform to its identity.
        let target = UIPreviewTarget(container: view, center: view.center, transform: transform)

        // Return the custom targeted preview
        return UITargetedPreview(view: preview, parameters: UIPreviewParameters(), target: target)
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
}

private extension CGAffineTransform {
    static func transformRect(from source: CGRect, toRect destination: CGRect) -> CGAffineTransform {
        return CGAffineTransform.identity
            .translatedBy(x: destination.midX - source.midX, y: destination.midY - source.midY)
            .scaledBy(x: destination.width / source.width, y: destination.height / source.height)
    }
}

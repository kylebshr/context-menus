//
//  CustomPreviewController.swift
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

class CustomPreviewController: UIViewController, ContextMenuDemo {

    // MARK: ContextMenuDemo

    static var title: String { return "UIViewController Preview" }

    // MARK: CustomPreviewController

    private let menuView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Self.title
        view.backgroundColor = .systemBackground

        menuView.backgroundColor = .systemBlue
        menuView.frame.size = .init(width: 100, height: 100)
        view.addSubview(menuView)

        /*********************************************************

         Here we create an interaction, give it a delegate, and
         add it to a view. This tells UIKit to call the delegate
         methods when the view is long-press or 3D touched, and
         display a menu if the delegate returns one.

         *********************************************************/

        let interaction = UIContextMenuInteraction(delegate: self)
        menuView.addInteraction(interaction)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuView.center = view.center
    }

    private func createPreviewViewController() -> UIViewController {
        return PreviewViewController()
    }
}

extension CustomPreviewController: UIContextMenuInteractionDelegate {

    /*********************************************************

     The `previewProvider` argument just needs a function
     that returns a view controller. You can do this with a
     closure, or pass in a method from your view controller.

     We can also implement `willPerformPreviewActionForMenuWith`
     to respond to the user tapping on the preview.

     *********************************************************/

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: createPreviewViewController) { suggestedActions in
            return self.makeDefaultDemoMenu()
        }
    }

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        let viewController = PreviewViewController()
        show(viewController, sender: self)
    }
}

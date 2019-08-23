//
//  VCPreviewSingleViewController.swift
//  ContextMenu
//
//  Created by Kyle Bashour on 8/20/19.
//  Copyright © 2019 Kyle Bashour. All rights reserved.
//

import UIKit

/*

 This view controller displays a square that can open a menu, and uses a view controller for the menu preview.
 When the preview is tapped, it pushes that view controller.

 */


/// A view controller used for previewing and when an item is selected
private class PreviewViewController: UIViewController {
    private let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        let mountains = UIImage(named: "mountains")!

        imageView.image = mountains
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        // The preview will size to the preferredContentSize, which can be useful
        // for displaying a preview with the dimension of an image, for example.
        // Unlike peek and pop, it doesn't automatically scale down for you.

        let width = view.bounds.width
        let height = mountains.size.height * (width / mountains.size.width)
        preferredContentSize = CGSize(width: width, height: height)
    }
}

class VCPreviewSingleViewController: UIViewController, ContextMenuDemo {

    // MARK: ContextMenuDemo

    static var title: String { return "UIViewController (Single View)" }

    // MARK: CustomPreviewController

    private let photoView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Self.title
        view.backgroundColor = .systemBackground

        photoView.image = UIImage(named: "mountains")
        photoView.contentMode = .scaleAspectFill
        photoView.clipsToBounds = true
        photoView.isUserInteractionEnabled = true
        photoView.frame.size = .init(width: 100, height: 100)
        view.addSubview(photoView)

        /*

         Here we create an interaction, give it a delegate, and
         add it to a view. This tells UIKit to call the delegate
         methods when the view is long-press or 3D touched, and
         display a menu if the delegate returns one.

         */

        let interaction = UIContextMenuInteraction(delegate: self)
        photoView.addInteraction(interaction)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        photoView.center = view.center
    }
}

extension VCPreviewSingleViewController: UIContextMenuInteractionDelegate {

    /*

     The `previewProvider` argument needs a function
     that returns a view controller. You can do this with a
     closure, or pass in a method that creates the view controller
     (in this case, the preview view controller initializer).

     We can also implement `willPerformPreviewActionForMenuWith`
     to respond to the user tapping on the preview.

     */

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: PreviewViewController.init) { suggestedActions in
            return self.makeDefaultDemoMenu()
        }
    }

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {

        // If we used a view controller for our preview, we can pull it out of the animator and show it once the commit animation is complete.
        animator.addCompletion {
            if let viewController = animator.previewViewController {
                self.show(viewController, sender: self)
            }
        }
    }
}

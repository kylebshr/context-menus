//
//  SuggestedActionsViewController.swift
//  ContextMenu
//
//  Created by Kyle Bashour on 9/2/19.
//  Copyright © 2019 Kyle Bashour. All rights reserved.
//


import UIKit

class SuggestedActionsViewController: UIViewController, ContextMenuDemo {
    
    // MARK: ContextMenuDemo

    static var title: String { return "Suggested Actions" }

    // MARK: SuggestedActionsViewController

    private weak var previewView: UIView?

    private let textView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Self.title
        view.backgroundColor = .white

        let interaction = UIContextMenuInteraction(delegate: self)
        textView.addInteraction(interaction)

        textView.font = .preferredFont(forTextStyle: .body)
        textView.textContainerInset = .init(top: 15, left: 10, bottom: 15, right: 10)
        textView.text = "This is a demo of suggested actions. Select some text, then open a context menu."
        view.addSubview(textView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.frame = view.bounds
    }

    // This method creates a text view that copies our real text view in appearance
    // - however it only shows the selected text.
    private func makeTextViewPreview() -> UIView {
        let preview = UITextView()

        let attributedText = NSMutableAttributedString(string: textView.text, attributes: [
            .font: textView.font!,
            .foregroundColor: UIColor.clear,
        ])

        attributedText.addAttributes([
            .foregroundColor: textView.textColor!
        ], range: textView.selectedRange)

        preview.attributedText = attributedText
        preview.frame = textView.bounds
        preview.textContainerInset = textView.textContainerInset
        preview.isUserInteractionEnabled = false

        previewView = preview

        return preview
    }

    // This method creates a UITargetedPreview for our selected text
    private func makeMenuPreview() -> UITargetedPreview? {

        // Check that we can get the selected text range
        guard let range = textView.selectedTextRange else {
            return nil
        }

        // UIPreviewParameters has a handy method that takes an array of text line rects and creates
        // parameters with a visible path containing those rects. However, that array is an array
        // of NSValue, so the docs say to "wrap each CGRect in an NSValue object."
        let selectionRects = textView.selectionRects(for: range).map { NSValue(cgRect: $0.rect) }

        // Create the parameters using our selected text line rects
        let parameters = UIPreviewParameters(textLineRects: selectionRects)

        // We need to ensure a visiblePath was created, as we need its center
        guard let visiblePath = parameters.visiblePath else {
            return nil
        }

        // When using a preview not in the view hierarchy, we need to specify a container view
        // and position by creating a UIPreviewTarget. In this case, we'll use our text view
        // and the center of our visible path.
        let target = UIPreviewTarget(container: textView, center: visiblePath.bounds.center)

        // Return a targeted preview using the parameters and target
        return UITargetedPreview(view: makeTextViewPreview(), parameters: parameters, target: target)
    }
}

extension SuggestedActionsViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {

        // We'll only create a context menu if there's some selected text
        guard let range = textView.selectedTextRange, let text = textView.text(in: range), !text.isEmpty else {
            return nil
        }

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in

            // Create your own actions
            let myCustomAction = UIAction(title: "Totally custom action") { _ in
                print("Selected custom action for selected text '\(text)'")
            }

            // Create a menu consisting of your own actions and the systems suggested actions
            return UIMenu(title: "", children: [myCustomAction] + suggestedActions)
        })
    }

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return makeMenuPreview()
    }

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForDismissingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return makeMenuPreview()
    }

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willEndFor configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        animator?.addAnimations { [weak self] in
            self?.previewView?.alpha = 0
        }
    }
}

private extension CGRect {
    // Computes the center of the receiver
    var center: CGPoint {
        return CGPoint(x: width / 2 + origin.x, y: height / 2 + origin.y)
    }
}

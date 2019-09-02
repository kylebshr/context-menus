import UIKit

class SuggestedActionsViewController: UIViewController, ContextMenuDemo {
    
    // MARK: ContextMenuDemo

    static var title: String { return "Suggested Actions" }

    private let textView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Self.title

        view.backgroundColor = .white
        textView.frame = CGRect(origin: .zero, size: .init(width: 100, height: 100))
        textView.backgroundColor = .secondarySystemBackground

        let interaction = UIContextMenuInteraction(delegate: self)
        textView.addInteraction(interaction)

        view.addSubview(textView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.center = view.center
    }
}

extension SuggestedActionsViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in

            let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in }
            let rename = UIAction(title: "Rename", image: UIImage(systemName: "square.and.pencil")) { action in }

            let deleteCancel = UIAction(title: "Cancel", image: UIImage(systemName: "xmark")) { action in }
            let deleteConfirmation = UIAction(title: "Delete", image: UIImage(systemName: "checkmark"), attributes: .destructive) { action in }

            // The delete sub-menu is created like the top-level menu, but we also specify an image and options
            let delete = UIMenu(title: "Delete", image: UIImage(systemName: "trash"), options: .destructive, children: [deleteCancel, deleteConfirmation])

            // The edit menu adds delete as a child, just like an action...
            let edit = UIMenu(title: "Edit...", children: [rename, delete])

            // ...then we add edit as a child of the main menu.
            return UIMenu(title: "", children: [share, edit] + suggestedActions)
        }
    }
}

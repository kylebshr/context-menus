//
//  TableViewController.swift
//  ContextMenu
//
//  Created by Kyle Bashour on 8/20/19.
//  Copyright © 2019 Kyle Bashour. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, ContextMenuDemo {

    // MARK: ContextMenuDemo

    static var title: String { return "Table View" }

    // MARK: TableViewController

    private let identifier = "identifier"

    private let lorem = [
        "Lorem ipsum",
        "dolor sit",
        "amet consectetur",
        "adipiscing elit",
        "sed do",
        "eiusmod tempor",
        "incididunt ut",
        "labore et",
        "dolore magna",
        "aliqua Ut",
        "enim ad",
        "minim veniam",
        "quis nostrud",
        "exercitation ullamco",
        "laboris nisi",
        "ut aliquip",
        "ex ea",
        "commodo consequat",
        "Duis aute",
        "irure dolor",
        "in reprehenderit",
        "in voluptate",
        "velit esse",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Self.title
        tableView.allowsSelection = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            return self.makeDefaultDemoMenu()
        }
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lorem.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = lorem[indexPath.row]
        return cell
    }
}

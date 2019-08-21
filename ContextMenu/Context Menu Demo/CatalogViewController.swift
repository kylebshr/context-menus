//
//  ViewController.swift
//  ContextMenu
//
//  Created by Kyle Bashour on 8/20/19.
//  Copyright © 2019 Kyle Bashour. All rights reserved.
//

import UIKit

class CatalogViewController: UITableViewController {
    private let identifier = "cell"

    typealias DemoViewController = ContextMenuDemo & UIViewController

    private let demos: [(title: String, viewControllers: [DemoViewController.Type])] = [
        ("Basic Menus", [
            SingleViewController.self,
            TableViewController.self,
            CollectionViewController.self,
        ]),
        ("Submenus", [
            SubmenuViewController.self,
            InlineSubmenuViewController.self,
        ]),

        ("Custom Previews", [
            CustomPreviewController.self,
            CustomPreviewTableViewController.self,
        ]),
    ]

    override init(style: UITableView.Style) {
        super.init(style: style)

        navigationItem.title = "Context Menu Demos"        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return demos.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demos[section].viewControllers.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return demos[section].title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = demos[indexPath.section].viewControllers[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = demos[indexPath.section].viewControllers[indexPath.row].init()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

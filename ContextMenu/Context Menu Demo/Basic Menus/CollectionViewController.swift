//
//  CollectionViewController.swift
//  ContextMenu
//
//  Created by Kyle Bashour on 8/20/19.
//  Copyright © 2019 Kyle Bashour. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, ContextMenuDemo {

    // MARK: ContextMenuDemo

    static var title: String { return "Collection View" }

    // MARK: CollectionViewController

    private let identifier = "cell"
    private let colors: [UIColor] = {
        return [
            UIColor.systemRed, .systemRed, .systemRed,
            .systemBlue, .systemBlue, .systemBlue,
            .systemPink, .systemPink, .systemPink,
            .systemGreen, .systemGreen, .systemGreen,
            .systemPurple, .systemPurple, .systemPurple,
            .systemTeal, .systemTeal, .systemTeal,
            .systemOrange, .systemOrange, .systemOrange
        ].shuffled()
    }()

    init() {
        super.init(collectionViewLayout: Self.makeCollectionViewLayout())
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Self.title

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private static func makeCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 3), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1.0 / 3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = .fixed(1)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 1

        return UICollectionViewCompositionalLayout(section: section)
    }

    // MARK: - UICollectionViewDelegate

    // Here's where we set up the context menu interaction
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            return self.makeDefaultDemoMenu()
        }
    }

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        cell.contentView.backgroundColor = colors[indexPath.row]
        cell.backgroundColor = colors[indexPath.row]
        return cell
    }
}

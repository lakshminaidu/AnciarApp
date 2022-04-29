//
//  ViewController.swift
//  AnciarApp
//
//  Created by Lakshminaidu on 29/4/2022.
//

import UIKit

let baseImageURL = "https://via.placeholder.com/"

class ViewController: UIViewController {

    static let sectionHeaderElementKind = "sectionheader"
    var data: [String] = [
        "cb47e2",
        "4dcdf6",
        "9ba35f",
        "1821a0",
        "a334b3",
        "6ffb88",
        "6aa9af",
        "4c48b8",
        "f6253f",
    ]
    
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Home"
        view.addSubview(collectionView)
        configureDataSource()
    }
}

extension ViewController {

    /// - Tag: Nested
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let firstItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0)))
            firstItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

            let secondItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(0.5)))
            secondItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            let firstGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(0.5)),
                subitem: firstItem, count: 2)
                     

            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .estimated(44)),
                elementKind: Self.sectionHeaderElementKind,
                alignment: .top)
            sectionHeader.pinToVisibleBounds = true
            let nestedGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(0.5)),
                subitems: [firstGroup, secondItem])
            let section = NSCollectionLayoutSection(group: nestedGroup)
            section.boundarySupplementaryItems = [sectionHeader]
            section.interGroupSpacing = 5
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            return section

        }
        return layout
    }
}

extension ViewController {
 
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<ItemCell, Int> { (cell, indexPath, identifier) in
            // Populate the cell with our item description.
            cell.contentView.backgroundColor = .lightGray
            cell.contentView.layer.cornerRadius = 8
            cell.label.text = "\(indexPath.row)"
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
            if (indexPath.row + 1) % 3 == 0 {
                cell.imageurl = baseImageURL + "300x150/" + self.data[indexPath.row]
            } else {
            
                cell.imageurl = baseImageURL + "150/" + self.data[indexPath.row]
            }
        }
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <HeaderSupplementaryView>(elementKind: Self.sectionHeaderElementKind) {
            (supplementaryView, string, indexPath) in
            supplementaryView.label.text = "Section \(indexPath.section)"
        }
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        var identifierOffset = 0
        let itemsPerSection = self.data.count
        for i in 0..<20 {
            snapshot.appendSections([i])
            let maxIdentifier = identifierOffset + itemsPerSection
            snapshot.appendItems(Array(identifierOffset..<maxIdentifier))
            identifierOffset += itemsPerSection
        }

        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


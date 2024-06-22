//
//  ImageListViewController+ImageDataSource.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/02/07.
//

import UIKit

final class ImageDataSource: UICollectionViewDiffableDataSource<Int, ImageListCellViewModel> {
    init(_ collectionView: UICollectionView) {
        super.init(collectionView: collectionView) { collectionView, indexPath, viewModel in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageListCell",
                                                                for: indexPath) as? ImageListCell
            else {
                fatalError("Failed to dequeue cell with reuse identifier ImageListCell")
            }
            cell.viewModel = viewModel
            return cell
        }
    }
}

// MARK: - Public functions
extension ImageDataSource {
    func apply(_ items: [ImageListCellViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ImageListCellViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)

        DispatchQueue.main.async {
            self.apply(snapshot,
                       animatingDifferences: false)
        }
    }
}

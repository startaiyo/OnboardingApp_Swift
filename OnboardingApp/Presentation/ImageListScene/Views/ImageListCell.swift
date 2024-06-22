//
//  ImageListCell.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/02/07.
//

import UIKit

final class ImageListCell: UICollectionViewCell {
    // MARK: Public properties
    var viewModel: ImageListCellViewModelProtocol! {
        didSet {
            setupBindings()
        }
    }

    // MARK: Private properties
    @IBOutlet private var imageView: UIImageView! {
        didSet {
            imageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet private var titleLabel: UILabel! {
        didSet {
            titleLabel.textAlignment = .center
        }
    }

    override func awakeFromNib() {
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}

// MARK: - Private functions
private extension ImageListCell {
    func setupUI() {
        backgroundColor = .lightGray
        layer.cornerRadius = 10
    }

    func setupBindings() {
        setImage()
        titleLabel.text = viewModel.title
    }

    func setImage() {
        Task {
            if let url = URL(string: viewModel.imageURLString) {
                let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
                Task { @MainActor in
                    imageView.image = UIImage(data: data)
                }
            }
        }
    }
}

//
//  ImageListCellViewModel.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/02/07.
//

import Foundation

protocol ImageListCellViewModelOutput {
    var title: String { get }
    var imageURLString: String { get }
    var image: ImageModel { get }
}

typealias ImageListCellViewModelProtocol = ImageListCellViewModelOutput

extension ImageListCellViewModel {
    struct Input {
        let image: ImageModel
    }
}

final class ImageListCellViewModel: Hashable {
    // MARK: Private properties
    let input: Input

    init(input: Input) {
        self.input = input
    }
}

// MARK: - ImageListCellViewModelOutput
extension ImageListCellViewModel: ImageListCellViewModelOutput {
    var title: String {
        return input.image.title
    }

    var imageURLString: String {
        return input.image.imageURLString
    }

    var image: ImageModel {
        return input.image
    }
}

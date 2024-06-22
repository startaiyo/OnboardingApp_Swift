//
//  ImageModel.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/02/19.
//

typealias ImageID = String

struct ImageModel {
    let id: ImageID
    let title: String
    let imageURLString: String
    let createdAt: String
}

extension ImageModel {
    func toDTO() -> ImageDTO {
        return .init(id: id,
                     title: title,
                     imageURLString: imageURLString,
                     createdAt: createdAt)
    }
}

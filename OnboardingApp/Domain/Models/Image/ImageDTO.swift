//
//  ImageDTO.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/03/01.
//

struct ImageDTO: Codable {
    let id: String
    let title: String
    let imageURLString: String
    let createdAt: String
}

extension ImageDTO {
    func toModel() -> ImageModel {
        return .init(id: id,
                     title: title,
                     imageURLString: imageURLString,
                     createdAt: createdAt)
    }

    func toObject() -> ImageObject {
        ImageObject(id: id,
                    title: title,
                    imageURLString: imageURLString,
                    createdAt: createdAt)
    }
}

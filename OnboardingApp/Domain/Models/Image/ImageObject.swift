//
//  ImageObject.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/03/01.
//

import RealmSwift

class ImageObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var imageURLString: String
    @Persisted var createdAt: String
}

extension ImageObject {
    convenience init(id: String,
                     title: String,
                     imageURLString: String,
                     createdAt: String) {
        self.init()
        self.id = id
        self.title = title
        self.imageURLString = imageURLString
        self.createdAt = createdAt
    }
}

extension ImageObject {
    func toDTO() -> ImageDTO {
        ImageDTO(id: id,
                 title: title,
                 imageURLString: imageURLString,
                 createdAt: createdAt)
    }
}

//
//  MessageObject.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/04/02.
//

import RealmSwift

class MessageObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var text: String
    @Persisted var image: ImageObject?
    @Persisted var createdAt: String
    @Persisted var userID: UserID
}

extension MessageObject {
    convenience init(id: String,
                     text: String,
                     image: ImageDTO?,
                     createdAt: String,
                     userID: UserID) {
        self.init()
        self.id = id
        self.text = text
        self.image = image?.toObject()
        self.createdAt = createdAt
        self.userID = userID
    }
}

extension MessageObject {
    func toDTO() -> MessageDTO {
        return .init(id: id,
                     text: text,
                     image: image?.toDTO(),
                     createdAt: createdAt,
                     userId: userID)
    }
}

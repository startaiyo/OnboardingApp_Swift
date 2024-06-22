//
//  MessageDTO.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/04/02.
//

import Foundation

struct MessageDTO: Codable {
    let id: String
    let text: String
    let image: ImageDTO?
    let createdAt: String
    let userId: UserID
}

extension MessageDTO {
    func toModel() throws -> MessageModel {
        return .init(id: id,
                     text: text,
                     image: image?.toModel(),
                     createdAt: try createdAt.dateFromString(),
                     userID: userId)
    }

    func toObject() -> MessageObject {
        return MessageObject(id: id,
                             text: text, 
                             image: image,
                             createdAt: createdAt,
                             userID: userId)
    }
}

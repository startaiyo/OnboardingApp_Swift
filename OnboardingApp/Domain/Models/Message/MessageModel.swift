//
//  MessageModel.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/04/02.
//

import Foundation

typealias MessageID = String

struct MessageModel {
    let id: MessageID
    let text: String
    let image: ImageModel?
    let createdAt: Date
    let userID: UserID
}

extension MessageModel {
    func toDTO() -> MessageDTO {
        return .init(id: id, 
                     text: text,
                     image: image?.toDTO(),
                     createdAt: createdAt.stringFromDate(),
                     userId: userID)
    }
}

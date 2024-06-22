//
//  UserDTO.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/04/05.
//

struct UserDTO: Codable {
    let userId: UserID
    let name: String
    let email: String
}

extension UserDTO {
    func toModel() -> UserModel {
        return .init(userID: userId,
                     name: name,
                     email: email)
    }
}

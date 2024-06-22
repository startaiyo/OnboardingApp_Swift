//
//  ImageInfoDTO.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/02/21.
//

struct ImageInfoDTO: Codable {
    let id: String
    let title: String
    let urls: ImageURLInfoDTO
    let createdAt: String
}

extension ImageInfoDTO {
    enum CodingKeys: String, CodingKey {
        case id
        case title = "alt_description"
        case urls
        case createdAt = "created_at"
    }
}

extension ImageInfoDTO {
    func toModel() -> ImageModel {
        return .init(id: id,
                     title: title,
                     imageURLString: urls.thumb,
                     createdAt: createdAt)
    }
}

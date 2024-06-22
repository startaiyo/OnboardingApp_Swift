//
//  ErrorsDTO.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/03/21.
//

enum NetworkError {
    case noInternetConnection
    case timeout
    case others(Error)
}

struct ServerError {
    let statusCode: Int
    let message: String
}

enum ErrorType {
    case general
    case network(NetworkError)
    case server(ServerError)
    case storage(String)
}

struct ErrorsDTO: Error {
    var type: ErrorType
}

extension ErrorsDTO {
    func toModel() -> ErrorsModel {
        .init(type: type)
    }
}

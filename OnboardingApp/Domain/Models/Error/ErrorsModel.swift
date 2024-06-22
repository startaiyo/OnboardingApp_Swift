//
//  ErrorsModel.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/03/21.
//

struct ErrorsModel: Error {
    var type: ErrorType
}

extension ErrorsModel {
    var title: String {
        switch type {
            case .general:
                return "Unknown error occured"
            case .network(let networkError):
                switch networkError {
                    case .noInternetConnection:
                        return "Connection failed"
                    case .timeout:
                        return "Connection time out"
                    case .others:
                        return "Network error occured"
                }
            case .server:
                return "Server error occured"
            case .storage:
                return "Storage operation failed"
        }
    }

    var description: String {
        switch type {
            case .general:
                return "please retry after a while."
            case .network(let networkError):
                switch networkError {
                    case .noInternetConnection:
                        return "there is no internet connection"
                    case .timeout:
                        return "the request is timed out"
                    case .others(let error):
                        return error.localizedDescription
                }
            case .server(let serverError):
                return serverError.message
            case .storage(let description):
                return description
        }
    }
}

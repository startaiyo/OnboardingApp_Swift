//
//  ApiClient.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/02/21.
//

import Foundation
import HTTPTypes

struct ApiClient { }

extension ApiClient: ApiClientProtocol {
    func call<T: CommonRequest>(request: T,
                                completionHandler: @escaping (Result<Data, ErrorsDTO>) -> Void) {
//        let request = createRequest(request)
        let request = createRequestForLegacy(request)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error as? URLError {
                completionHandler(.failure(convertToDTO(error)))
                return
            } else if error != nil {
                completionHandler(.failure(.init(type: .general)))
            }

            guard let data,
                  let response = response as? HTTPURLResponse else {
                completionHandler(.failure(.init(type: .general)))
                return
            }

            if response.statusCode == 200 {
                completionHandler(.success(data))
            } else {
                completionHandler(.failure(.init(type: .server(.init(statusCode: response.statusCode,
                                                                     message: String(data: data,
                                                                                     encoding: .utf8) ?? "")))))
            }

        }
        task.resume()
    }
//    func call<T: CommonRequest>(request: T) async throws -> Data {
//        let request = createRequest(request)
//        let (data, response) = try await URLSession.shared.data(for: request)
//        if response.status == .ok {
//            return data
//        } else {
//            throw NSError(domain: response.debugDescription, 
//                          code: 500)
//        }
//    }
}

private extension ApiClient {
//    func createRequest(_ r: CommonRequest) -> HTTPRequest {
//        var request = HTTPRequest(url: URL(string: r.baseUrlString)!)
//        request.method = r.method
//        let queryStrings = r.parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
//        request.path = "\(r.path)?\(queryStrings)"
//        r.headerFields.forEach {
//            request.headerFields[$0.key] = $0.value
//        }
//        return request
//    }

    func createRequestForLegacy(_ r: CommonRequest) -> URLRequest {
        let queryStrings = r.parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        let searchURL = URL(string: r.baseUrlString + r.path + "?" + queryStrings)!
        var request = URLRequest(url: searchURL)
        request.httpMethod = r.method
        r.headerFields.forEach {
            request.addValue($0.value,
                             forHTTPHeaderField: $0.key)
        }
        return request
    }

    func convertToDTO(_ error: URLError) -> ErrorsDTO {
        switch error.code {
            case .notConnectedToInternet,
                    .networkConnectionLost:
                return .init(type: .network(.noInternetConnection))
            case .timedOut:
                return .init(type: .network(.timeout))
            default:
                return .init(type: .network(.others(error)))
        }
    }
}

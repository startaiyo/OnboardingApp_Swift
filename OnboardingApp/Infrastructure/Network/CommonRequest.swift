//
//  CommonRequest.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/02/21.
//

// 残り
import HTTPTypes
import HTTPTypesFoundation

protocol CommonRequest {
    var baseUrlString: String { get }
    var path: String { get }
//    var method: HTTPRequest.Method { get }
//    var headerFields: [HTTPField.Name: String] { get }
    var method: String { get }
    var headerFields: [String: String] { get }
    var parameters: [String: String] { get }
}

extension CommonRequest {
    var baseUrlString: String { "https://api.unsplash.com" }
    var path: String { "/search/photos" }
//    var headerFields: [HTTPField.Name: String] { [:] }
    var headerFields: [String: String] { [:] }
    var parameters: [String: String]? { [:] }
}

// 残り
enum ImageKeys: String {
    case client_id
    case query
}

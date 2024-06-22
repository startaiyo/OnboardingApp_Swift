//
//  ImageRequest.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/02/20.
//

import HTTPTypes

struct ImageRequest: CommonRequest {
//    var headerFields: [HTTPField.Name : String]
    var headerFields: [String : String]
//    let method: HTTPRequest.Method = .get
    let method: String = "GET"
    let parameters: [String: String]

    init(input: ImageInput) {
        let encodedSearchQuery = input.searchQuery.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        var params: [ImageKeys: String] = [:]
        params[.client_id] = "RfPaSS25BVF9uT660u_ni-A876dw_1pYhmF1fYcg9-E"
//        params[.client_id] = "RfPaSS25BVF9uT660u_ni-A876dw_1pYhmF1"
        params[.query] = encodedSearchQuery
//        var headers: [HTTPField.Name: String] = [:]
        var headers: [String: String] = [:]
        headers["contentType"] = "application/json"
//        headers[.contentType] = "application/json"

        var rawKeyParams: [String: String] = [:]
        params.forEach { rawKeyParams[$0.key.rawValue] = $0.value }
        parameters = rawKeyParams
        headerFields = headers
    }
}

struct ImageInput {
    let searchQuery: String
}

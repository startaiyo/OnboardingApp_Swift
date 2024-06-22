//
//  ApiClientProtocol.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/02/21.
//

import Foundation

protocol ApiClientProtocol {
    func call<T: CommonRequest>(request: T,
                                completionHandler: @escaping (Result<Data, ErrorsDTO>) -> Void)
}

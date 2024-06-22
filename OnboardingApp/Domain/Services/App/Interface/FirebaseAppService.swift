//
//  FirebaseAppService.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/03/06.
//

import FirebaseAuth

protocol FirebaseAppService {
    static var sharedInstance: FirebaseAppService { get }
    var currentUser: User? { get }
    func registerUser(email: String,
                      password: String) async throws -> String
    func signinUser(email: String,
                    password: String) async throws
    func signoutUser() throws
    func createData(to collectionName: String,
                    of document: String,
                    data: [String: Any])
    func readAll<T: Codable>(from collectionName: String,
                             type: T.Type,
                             completionHandler: @escaping (Result<[T], ErrorsModel>) -> Void)
    func readData<T: Codable>(from collectionName: String,
                              of document: String,
                              type: T.Type) async throws -> T?
}

struct CollectionName {
    static let images = "images"
    static let messages = "messages"
    static let users = "users"
}

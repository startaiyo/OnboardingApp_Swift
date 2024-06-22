//
//  DefaultFirebaseAppService.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/03/06.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

final class DefaultFirebaseAppService {
    let auth: Auth
    let db: Firestore

    init() {
        FirebaseApp.configure()
        db = Firestore.firestore()
        auth = Auth.auth()
    }
}

// MARK: - FirebaseAppService
extension DefaultFirebaseAppService: FirebaseAppService {
    var currentUser: User? {
        return auth.currentUser
    }
    
    func registerUser(email: String, 
                      password: String) async throws -> String {
        let result = try await auth.createUser(withEmail: email,
                                               password: password)
        return result.user.uid
    }
    
    func signinUser(email: String, 
                    password: String) async throws {
        try await auth.signIn(withEmail: email,
                              password: password)
    }
    
    func signoutUser() throws {
        try auth.signOut()
    }
    
    static let sharedInstance: FirebaseAppService = {
        return DefaultFirebaseAppService()
    }()

    func createData(to collectionName: String,
                    of document: String,
                    data: [String: Any]) {
        db.collection(collectionName).document(document).setData(data)
    }

    func readData<T: Codable>(from collectionName: String,
                              of document: String,
                              type: T.Type) async throws -> T? {
        let data = try await db.collection(collectionName).document(document).getDocument(source: .default).data(as: T.self)
        return data
    }

    func readAll<T: Codable>(from collectionName: String,
                             type: T.Type,
                             completionHandler: @escaping (Result<[T], ErrorsModel>) -> Void) {
        db.collection(collectionName).getDocuments { (querySnapshot, error) in
            if let querySnapshot {
                do {
                    completionHandler(.success(try querySnapshot.documents.map { try $0.data(as: T.self) }))
                } catch {
                    completionHandler(.failure(.init(type: .server(.init(statusCode: 500,
                                                                         message: error.localizedDescription)))))
                }
            }
        }
    }
}

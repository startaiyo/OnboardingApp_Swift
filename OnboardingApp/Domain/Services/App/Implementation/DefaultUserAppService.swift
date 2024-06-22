//
//  DefaultUserAppService.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/04/05.
//

final class DefaultUserAppService {
    // MARK: Private properties
    private let firebaseAppService: FirebaseAppService

    init(firebaseAppService: FirebaseAppService = DefaultFirebaseAppService.sharedInstance) {
        self.firebaseAppService = firebaseAppService
    }
}

extension DefaultUserAppService: UserAppService {
    func getCurrentUser() async throws -> UserModel {
        if let currentUser = firebaseAppService.currentUser,
           let user = try await firebaseAppService.readData(from: CollectionName.users,
                                                            of: currentUser.uid,
                                                            type: UserDTO.self) {
            return .init(userID: currentUser.uid,
                         name: user.name,
                         email: user.email)
        } else {
            throw ErrorsModel(type: .general)
        }
    }
    
    func getUser(_ userID: UserID) async throws -> UserModel {
        if let user = try await firebaseAppService.readData(from: CollectionName.users,
                                                            of: userID,
                                                            type: UserDTO.self)?.toModel() {
            return user
        } else {
            throw ErrorsModel(type: .general)
        }
    }
    
    func saveUser(_ uid: String, 
                  ofName name: String,
                  withEmail email: String) {
        firebaseAppService.createData(to: CollectionName.users,
                                      of: uid,
                                      data: ["userId": uid,
                                             "name": name,
                                             "email": email])
    }
}

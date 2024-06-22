//
//  DefaultAuthAppService.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/04/05.
//

final class DefaultAuthAppService {
    private let userAppService: UserAppService
    private let firebaseAppService: FirebaseAppService
    init(userAppService: UserAppService = DefaultUserAppService(),
         firebaseAppService: FirebaseAppService = DefaultFirebaseAppService.sharedInstance) {
        self.userAppService = userAppService
        self.firebaseAppService = firebaseAppService
    }
}

extension DefaultAuthAppService: AuthAppService {
    func registerAccount(name: String,
                         email: String,
                         password: String) async throws {
        let uid = try await firebaseAppService.registerUser(email: email,
                                                            password: password)
        userAppService.saveUser(uid,
                                ofName: name,
                                withEmail: email)
    }

    func signIn(email: String,
                password: String) async throws {
        try await firebaseAppService.signinUser(email: email,
                                                password: password)
    }

    func signOut() throws {
        try firebaseAppService.signoutUser()
    }
}

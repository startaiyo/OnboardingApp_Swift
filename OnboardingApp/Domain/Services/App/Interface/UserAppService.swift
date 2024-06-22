//
//  UserAppService.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/04/05.
//

protocol UserAppService {
    func getCurrentUser() async throws -> UserModel
    func getUser(_ userID: UserID) async throws -> UserModel
    func saveUser(_ uid: String,
                  ofName name: String,
                  withEmail email:String)
}

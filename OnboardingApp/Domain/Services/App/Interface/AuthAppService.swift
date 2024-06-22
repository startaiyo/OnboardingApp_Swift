//
//  AuthAppService.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/04/05.
//

protocol AuthAppService {
    func registerAccount(name: String,
                         email: String,
                         password: String) async throws
    func signIn(email: String,
                password: String) async throws
    func signOut() throws
}

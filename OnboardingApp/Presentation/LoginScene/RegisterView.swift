//
//  RegisterView.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/04/04.
//

import SwiftUI

struct RegisterView: View {
    private let authAppService = DefaultAuthAppService()
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var errorMessage = ""
    @State var isError = false
    let onCompletion: () -> Void

    var body: some View {
        VStack {
            TextField("name", 
                      text: $name)
                .textFieldStyle(.roundedBorder)
            TextField("email",
                      text: $email)
                .textFieldStyle(.roundedBorder)
            TextField("password",
                      text: $password)
                .textFieldStyle(.roundedBorder)
            Button("register") {
                register()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .alert(isPresented: $isError) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage)
            )
        }
    }

    func register() {
        Task {
            do {
                _ = try await authAppService.registerAccount(name: name,
                                                             email: email,
                                                             password: password)
                onCompletion()
            } catch {
                Task { @MainActor in
                    isError = true
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    RegisterView(onCompletion: {})
}

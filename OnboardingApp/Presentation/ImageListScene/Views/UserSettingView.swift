//
//  UserSettingView.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/04/08.
//

import SwiftUI

struct UserSettingView: View {
    let userAppService: UserAppService
    let authAppService: AuthAppService
    let onLogout: () -> Void

    @State var user: UserModel? = nil

    var body: some View {
        VStack {
            HStack {
                Text("name: ")
                Text(user?.name ?? "(unavailable)")
            }
            HStack {
                Text("email: ")
                Text(user?.email ?? "(unavailable)")
            }
            Button("Logout", 
                   role: .destructive) {
                logout()
            }
        }
        .onAppear {
            getUserSettings()
        }
    }

    func getUserSettings() {
        Task {
            do {
                user = try await userAppService.getCurrentUser()
            } catch {
                print(error)
            }
        }
    }

    func logout() {
        do {
            try authAppService.signOut()
            onLogout()
        } catch {
            print(error)
        }
    }
}

#Preview {
    UserSettingView(userAppService: DefaultUserAppService(),
                    authAppService: DefaultAuthAppService(),
                    onLogout: {})
}

//
//  LoginViewModelTests.swift
//  OnboardingAppTests
//
//  Created by Shotaro Doi on 2024/04/12.
//

@testable import OnboardingApp
import Quick
import Nimble

class TableOfContentsSpec: QuickSpec {
    override class func spec() {
        var sut: LoginViewModel!
        var authAppService: AuthAppServiceMock!

        afterEach {
            sut = nil
            authAppService = nil
        }

        describe("login") {
            
        }
    }
}

final class AuthAppServiceMock: AuthAppService {
    func registerAccount(name: String, 
                         email: String,
                         password: String) async throws {
        <#code#>
    }
    
    func signIn(email: String, 
                password: String) async throws {
        <#code#>
    }
    
    func signOut() throws {
        <#code#>
    }
}

//
//  LoginViewModelTests.swift
//  OnboardingAppTests
//
//  Created by Shotaro Doi on 2024/04/12.
//

@testable import OnboardingApp
import Foundation
import Quick
import Nimble

class TableOfContentsSpec: AsyncSpec {
    override class func spec() {
        var sut: LoginViewModel!
        var authAppService: AuthAppServiceMock!
        var coordinationDelegate: LoginViewModelCoordinationsMock!
        var showInsufficientTextTask: Task<Void, Never>?
        var errorsTask: Task<Void, Never>?
        let resultQueue = DispatchQueue(label: "com.test.resultQueue")

        afterEach {
            sut = nil
            authAppService = nil
            coordinationDelegate = nil
            showInsufficientTextTask?.cancel()
            errorsTask?.cancel()
            showInsufficientTextTask = nil
            errorsTask = nil
        }

        describe("showRegisterScreen") {
            beforeEach {
                authAppService = AuthAppServiceMock()
                coordinationDelegate = LoginViewModelCoordinationsMock()
                sut = LoginViewModel(input: .init(authAppService: authAppService))
                sut.coordinationDelegate = coordinationDelegate
            }

            it("propagates the event to coordination delegate") {
                sut.showRegisterScreen()

                expect(coordinationDelegate.didRequestToShowRegisterScreenCallCount) == 1
            }
        }

//        describe("login") {
//            beforeEach {
//                authAppService = AuthAppServiceMock()
//                coordinationDelegate = LoginViewModelCoordinationsMock()
//                sut = LoginViewModel(input: .init(authAppService: authAppService))
//                sut.coordinationDelegate = coordinationDelegate
//            }
//
//            context("if the email or the password is empty") {
//                it("triggers shouldShowInsufficientTextSubject to emit true") {
//                    var result: Bool?
////                    let resultQueue = DispatchQueue(label: "com.test.resultQueue")
//
//                    showInsufficientTextTask = Task { [sut] in
//                        for await shouldShow in sut!.shouldShowInsufficientTextSubject {
////                            resultQueue.sync {
//                                result = shouldShow
////                            }
//                        }
//                    }
//
//                    sut.login(email: nil, password: "not nil")
//
//                    waitUntil { done in
//                        resultQueue.async {
//                            expect(result).to(beTrue())
//                            done()
//                        }
//                    }
//                }
//            }
//
//            context("if both the email and the password are not empty") {
//                it("triggers shouldShowInsufficientTextSubject to emit false") {
//                    var result: Bool?
//
//                    showInsufficientTextTask = Task { [sut] in
//                        for await shouldShow in sut!.shouldShowInsufficientTextSubject {
//                            resultQueue.sync {
//                                result = shouldShow
//                            }
//                        }
//                    }
//
//                    sut.login(email: "not nil", password: "not nil")
//
//                    waitUntil { done in
//                        resultQueue.async {
//                            expect(result).to(beFalse())
//                            done()
//                        }
//                    }
//                }
//
//                context("if the sign-in succeeds") {
//                    it("propagates the event to the coordination delegate") {
//                        authAppService.isSignInFail = false
//
//                        sut.login(email: "not nil", password: "not nil")
//
//                        expect(coordinationDelegate.didRequestToShowBaseTabScreenCallCount).toEventually(equal(1))
//                    }
//                }
//
//                context("if the sign-in fails") {
//                    it("triggers errorsSubject to emit 500 server error") {
//                        authAppService.isSignInFail = true
//                        var error: Error?
//
//                        errorsTask = Task { [sut] in
//                            for await err in sut!.errorsSubject {
//                                resultQueue.async {
//                                    error = err
//                                }
//                            }
//                        }
//
//                        sut.login(email: "not nil", password: "not nil")
//
//                        waitUntil { done in
//                            expect(error).toEventuallyNot(beNil())
//                            if let error = error as? ErrorsModel, case .server(let errorDetails) = error.type {
//                                expect(errorDetails.statusCode).to(equal(500))
//                                done()
//                            }
//                        }
//                    }
//                }
//            }
//        }
    }
}

final class AuthAppServiceMock: AuthAppService {
    func registerAccount(name: String, 
                         email: String,
                         password: String) async throws { }

    var isSignInFail: Bool?
    private(set) var signInCallCount = 0
    private(set) var emailFromSignIn: String?
    private(set) var passwordFromSignIn: String?
    func signIn(email: String,
                password: String) async throws {
        signInCallCount += 1
        emailFromSignIn = email
        passwordFromSignIn = password

        if isSignInFail == true {
            throw ErrorsModel(type: .general)
        }
    }

    func signOut() throws { }
}

fileprivate class LoginViewModelCoordinationsMock: LoginViewModelCoordinations {
    private(set) var didRequestToShowBaseTabScreenCallCount = 0
    func loginViewModelDidRequestToShowBaseTabScreen(_ viewModel: LoginViewModelProtocol) {
        didRequestToShowBaseTabScreenCallCount += 1
    }

    private(set) var didRequestToShowRegisterScreenCallCount = 0
    func loginViewModelDidRequestToShowRegisterScreen(_ viewModel: LoginViewModelProtocol) {
        didRequestToShowRegisterScreenCallCount += 1
    }
}

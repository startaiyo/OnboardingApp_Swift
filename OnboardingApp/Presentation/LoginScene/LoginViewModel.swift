//
//  LoginViewModel.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/04/04.
//

protocol LoginViewModelCoordinations: AnyObject {
    func loginViewModelDidRequestToShowBaseTabScreen(_ viewModel: LoginViewModelProtocol)
    func loginViewModelDidRequestToShowRegisterScreen(_ viewModel: LoginViewModelProtocol)
}

protocol LoginViewModelInput {
    func login(email: String?,
               password: String?)
    func showRegisterScreen()
}

protocol LoginViewModelOutput {
    var shouldShowInsufficientTextSubject: AsyncStream<Bool> { get }
    var errorsSubject: AsyncStream<ErrorsModel> { get }
    var invalidAlertText: String { get }
}

typealias LoginViewModelProtocol = LoginViewModelInput & LoginViewModelOutput

extension LoginViewModel {
    struct Input {
        let authAppService: AuthAppService
    }
}

final class LoginViewModel {
    // MARK: Public properties
    weak var coordinationDelegate: LoginViewModelCoordinations?

    // MARK: Private properties
    private let input: Input
    private var shouldShowInsufficientTextHandler: ((Bool) -> Void)?
    private var errorsHandler: ((ErrorsModel) -> Void)?

    init(input: Input) {
        self.input = input
    }
}

// MARK: - LoginViewModelInput
extension LoginViewModel: LoginViewModelInput {
    func login(email: String?,
               password: String?) {
        Task {
            do {
                guard let email, 
                      let password,
                      !email.isEmpty,
                      !password.isEmpty
                else {
                    shouldShowInsufficientTextHandler?(true)
                    return
                }
                shouldShowInsufficientTextHandler?(false)
                try await input.authAppService.signIn(email: email,
                                                      password: password)
                coordinationDelegate?.loginViewModelDidRequestToShowBaseTabScreen(self)
            } catch {
                errorsHandler?(.init(type: .server(.init(statusCode: 500,
                                                         message: error.localizedDescription))))
            }
        }
    }

    func showRegisterScreen() {
        coordinationDelegate?.loginViewModelDidRequestToShowRegisterScreen(self)
    }
}

// MARK: - LoginViewModelOutput
extension LoginViewModel: LoginViewModelOutput {
    var shouldShowInsufficientTextSubject: AsyncStream<Bool> {
        return AsyncStream { continuation in
            shouldShowInsufficientTextHandler = { shouldShow in
                continuation.yield(shouldShow)
            }
        }
    }

    var errorsSubject: AsyncStream<ErrorsModel> {
        return AsyncStream { continuation in
            errorsHandler = { error in
                continuation.yield(error)
            }
        }
    }

    var invalidAlertText: String {
        return "please fill both of email and password"
    }
}

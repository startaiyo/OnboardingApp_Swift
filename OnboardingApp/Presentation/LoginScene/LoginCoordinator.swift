//
//  LoginCoordinator.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/02/04.
//

import UIKit
import SwiftUI

protocol LoginCoordinatorDelegate: AnyObject {
    func goToTabBar()
}

final class LoginCoordinator {
    // parent
    private let window: UIWindow
    private let navigationController = UINavigationController()
    private let authAppService = DefaultAuthAppService()
    weak var delegate: LoginCoordinatorDelegate?
    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        showLogin(in: navigationController)
    }
}

// MARK: - Private Functions
private extension LoginCoordinator {
    func showLogin(in navigationController: UINavigationController) {
        let storyboard = UIStoryboard(name: "Login",
                                      bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            let viewModel = LoginViewModel(input: .init(authAppService: authAppService))
            viewModel.coordinationDelegate = self
            vc.viewModel = viewModel
            navigationController.setViewControllers([vc],
                                                    animated: true)
            window.rootViewController = navigationController
        }
    }

    func showImageList() {
        let imageListCoordinator = ImageListCoordinator(navigationController: navigationController)
        imageListCoordinator.start()
    }

    func showBaseTabScreen() {
        Task { @MainActor in
            delegate?.goToTabBar()
        }
    }
}

// MARK: - LoginViewControllerDelegate
extension LoginCoordinator: LoginViewModelCoordinations {
    func loginViewModelDidRequestToShowBaseTabScreen(_ viewModel: LoginViewModelProtocol) {
        showBaseTabScreen()
    }
    
    func loginViewModelDidRequestToShowRegisterScreen(_ viewModel: LoginViewModelProtocol) {
        let viewController = UIHostingController(rootView: RegisterView(onCompletion: {
            Task { @MainActor [weak self] in
                self?.navigationController.popViewController(animated: false)
                self?.delegate?.goToTabBar()
            }
        }))
        navigationController.pushViewController(viewController,
                                                animated: false)
    }
}

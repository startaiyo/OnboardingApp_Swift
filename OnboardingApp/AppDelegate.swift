//
//  AppDelegate.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/01/31.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: Public properties
    var window: UIWindow?
    // MARK: Private properties
    private var loginCoordinator: LoginCoordinator?
    private var baseTabCoordinator: BaseTabCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 一つのスクリーンを表すインスタンス。Keyになっているものがユーザーのアクションを受け取る。
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        showLoginScreen()

        return true
    }
}

// MARK: - Private functions
private extension AppDelegate {
    func showLoginScreen() {
        if let window,
           loginCoordinator == nil {
            loginCoordinator = LoginCoordinator(window: window)
            loginCoordinator?.delegate = self
            loginCoordinator?.start()
        }
        baseTabCoordinator = nil
    }

    func showBaseTabScreen() {
        if let window,
           baseTabCoordinator == nil {
            baseTabCoordinator = BaseTabCoordinator(window: window)
            baseTabCoordinator?.delegate = self
            baseTabCoordinator?.start()
        }
        loginCoordinator = nil
    }
}

// MARK: - LoginCoordinatorDelegate
extension AppDelegate: LoginCoordinatorDelegate {
    func goToTabBar() {
        showBaseTabScreen()
    }
}

extension AppDelegate: BaseTabCoordinatorDelegate {
    func baseTabCoordinatorDidLogout(_ coordinator: BaseTabCoordinator) {
        showLoginScreen()
    }
}

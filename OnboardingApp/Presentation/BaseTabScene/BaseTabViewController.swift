//
//  BaseTabViewController.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/02/04.
//

import UIKit

final class BaseTabViewController: UITabBarController {
    class func initialize(navigationControllers: [UINavigationController]) -> BaseTabViewController {
        let viewController = BaseTabViewController()
        viewController.setViewControllers(navigationControllers,
                                          animated: false)
        viewController.setupUI()
        return viewController
    }
}

// MARK: - Private properties
private extension BaseTabViewController {
    func setupUI() {
        setupTabBar()
    }

    func setupTabBar() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .yellow
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        tabBar.isTranslucent = false
        tabBar.tintColor = .black
    }
}

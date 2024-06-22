//
//  BaseTabCoordinator.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/02/04.
//

import UIKit

protocol BaseTabCoordinatorDelegate: AnyObject {
    func baseTabCoordinatorDidLogout(_ coordinator: BaseTabCoordinator)
}

final class BaseTabCoordinator {
    // MARK: Public properties
    weak var delegate: BaseTabCoordinatorDelegate?
    // MARK: Private properties
    private let window: UIWindow
    private var rootViewController: BaseTabViewController?

    private lazy var imageListNavigationController: UINavigationController = {
        let navigationController = UINavigationController()
        setupNavigationViewController(navigationController)
        navigationController.tabBarItem.title = "Image List"
        navigationController.tabBarItem.image = UIImage(systemName: "photo")
        return navigationController
    }()

    private lazy var imageListCoordinator: ImageListCoordinator = {
        let coordinator = ImageListCoordinator(navigationController: imageListNavigationController)
        coordinator.delegate = self
        return coordinator
    }()

    private lazy var chatNavigationController: UINavigationController = {
        let navigationController = UINavigationController()
        setupNavigationViewController(navigationController)
        navigationController.tabBarItem.title = "Chat"
        navigationController.tabBarItem.image = UIImage(systemName: "person.2.fill")
        return navigationController
    }()

    private lazy var chatCoordinator: ChatCoordinator = {
        let coordinator = ChatCoordinator(navigationController: chatNavigationController)
        return coordinator
    }()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let viewControllers = [imageListNavigationController, chatNavigationController]
        rootViewController = BaseTabViewController.initialize(navigationControllers: viewControllers)
        window.rootViewController = rootViewController
        imageListCoordinator.start()
        chatCoordinator.start()
    }
}

// MARK: - Private functions
private extension BaseTabCoordinator {
    func setupNavigationViewController(_ navigationController: UINavigationController) {
        navigationController.navigationBar.isTranslucent = false
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .yellow
        navigationController.navigationBar.standardAppearance = appearance
        // これを設定しないと、スクロールし切った状態(スクロールできない状態を含む)のナビゲーションバーがdefault設定(真っ黒)になる。
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    }
}

// MARK: - ImageListCoordinatorDelegate
extension BaseTabCoordinator: ImageListCoordinatorDelegate {
    func imageListCoordinatorDidLogout(_ coordinator: ImageListCoordinator) {
        delegate?.baseTabCoordinatorDidLogout(self)
    }
    
    func imageListCoordinator(_ coordinator: ImageListCoordinator, 
                              didRequestToSendMessageWith cellViewModel: ImageListCellViewModel) {
        chatCoordinator.sendMessage(with: cellViewModel)
        rootViewController?.selectedIndex = 1
    }
}

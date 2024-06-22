//
//  ImageListCoordinator.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/02/04.
//

import UIKit
import SwiftUI

protocol ImageListCoordinatorDelegate: AnyObject {
    func imageListCoordinator(_ coordinator: ImageListCoordinator,
                              didRequestToSendMessageWith cellViewModel: ImageListCellViewModel)
    func imageListCoordinatorDidLogout(_ coordinator: ImageListCoordinator)
}

final class ImageListCoordinator {
    // MARK: Public properties
    weak var delegate: ImageListCoordinatorDelegate?

    // MARK: Private properties
    private let navigationController: UINavigationController
    private let imageAppService = DefaultImageAppService()
    private let userAppService = DefaultUserAppService()
    private let authAppService = DefaultAuthAppService()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showImageListScreen()
    }
}

private extension ImageListCoordinator {
    func showImageListScreen() {
        let storyboard = UIStoryboard(name: "ImageList",
                                      bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "ImageListViewController") as? ImageListViewController {
            let viewModel = ImageListViewModel(input: .init(imageAppService: imageAppService))
            viewController.viewModel = viewModel
            viewModel.coordinationDelegate = self
            navigationController.pushViewController(viewController,
                                                    animated: true)
        }
    }

    func showUserSettingScreen() {
        let viewController = UIHostingController(rootView: UserSettingView(userAppService: userAppService,
                                                                           authAppService: authAppService,
                                                                           onLogout: onLogout))
        navigationController.pushViewController(viewController,
                                                animated: true)
    }

    func onLogout() {
        delegate?.imageListCoordinatorDidLogout(self)
    }
}

extension ImageListCoordinator: ImageListViewModelCoordinations {
    func imageListViewModel(_ viewModel: ImageListViewModelProtocol, 
                            didRequestToSendMessageWith cellViewModel: ImageListCellViewModel) {
        delegate?.imageListCoordinator(self,
                                       didRequestToSendMessageWith: cellViewModel)
    }

    func imageListViewModelDidRequestToUserSettingScene(_ viewModel:  ImageListViewModelProtocol) {
        showUserSettingScreen()
    }
}

//
//  ChatCoordinator.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/03/27.
//

import SwiftUI

final class ChatCoordinator {
    // MARK: Private properties
    private let navigationController: UINavigationController
    private let messageAppService = DefaultMessageAppService()
    private let userAppService = DefaultUserAppService()
    private var chatViewModel: ChatViewModel?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = ChatViewModel(messageAppService: messageAppService,
                                      userAppService: userAppService)
        chatViewModel = viewModel
        let view = UIHostingController(rootView: ChatView(viewModel: viewModel))
        view.navigationItem.title = "Chat"
        navigationController.pushViewController(view,
                                                animated: true)
    }
}

// MARK: - Public functions
extension ChatCoordinator {
    func sendMessage(with cellViewModel: ImageListCellViewModel) {
        chatViewModel?.sendMessage(withText: cellViewModel.title,
                                   andImage: cellViewModel.image)
    }
}

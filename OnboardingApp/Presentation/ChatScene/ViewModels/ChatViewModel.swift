//
//  ChatViewModel.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/03/29.
//

import SwiftUI

final class ChatViewModel: ObservableObject {
    @Published var messages = [MessageModel]()
    @Published var isError: Bool = false
    @Published var errorMessage: String = ""
    @Published var currentUser: UserModel?
    

    private let messageAppService: MessageAppService
    let userAppService: UserAppService

    init(messageAppService: MessageAppService,
         userAppService: UserAppService) {
        self.messageAppService = messageAppService
        self.userAppService = userAppService
        fetchMessages()
        setCurrentUser()
    }

    func sendMessage(withText text: String,
                     andImage image: ImageModel? = nil) {
        guard let currentUser else { return }
        let messageID = UUID().uuidString
        messageAppService.saveMessage(.init(id: messageID,
                                            text: text,
                                            image: image,
                                            createdAt: Date(),
                                            userID: currentUser.userID)) {
            self.fetchMessages()
        }
    }

    func fetchMessages() {
        messageAppService.getMessages(cacheCompletionHandler: { cachedMessage in
            guard let cachedMessage else { return }
            Task { @MainActor in
                self.messages = cachedMessage
            }
        }) { [weak self] result in
            switch result {
            case .success(let messages):
                Task { @MainActor [weak self] in
                    self?.messages = messages
                }
            case .failure(let error):
                self?.isError = true
                self?.errorMessage = error.description
            }
        }
    }

    func setCurrentUser() {
        Task {
            do {
                currentUser = try await userAppService.getCurrentUser()
            } catch {
                print(error)
            }
        }
    }

    func onDismissError() {
        isError = false
        errorMessage = ""
    }
}

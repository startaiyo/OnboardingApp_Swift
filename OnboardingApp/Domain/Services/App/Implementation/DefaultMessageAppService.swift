//
//  DefaultMessageAppService.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/04/02.
//

final class DefaultMessageAppService {
    // MARK: Private properties
    private let firebaseAppService: FirebaseAppService
    private let messageStorageService: MessageStorageService

    init(firebaseAppService: FirebaseAppService = DefaultFirebaseAppService.sharedInstance,
         messageStorageService: MessageStorageService = DefaultMessageStorageService()) {
        self.firebaseAppService = firebaseAppService
        self.messageStorageService = messageStorageService
    }
}

extension DefaultMessageAppService: MessageAppService {
    func saveMessage(_ message: MessageModel,
                     completionHandler: @escaping () -> Void) {
        var data: [String: Any]?
        if let image = message.image {
            data = ["id": image.id,
                    "title": image.title,
                    "imageURLString": image.imageURLString,
                    "createdAt": image.createdAt]
        }
        firebaseAppService.createData(to: CollectionName.messages,
                                      of: message.id,
                                      data: ["id": message.id,
                                             "text": message.text,
                                             "image": data as Any,
                                             "createdAt": message.createdAt.stringFromDate(),
                                             "userId": message.userID])
        completionHandler()
    }

    func getMessages(cacheCompletionHandler: @escaping ([MessageModel]?) -> Void,
                     completionHandler: @escaping (Result<[MessageModel], ErrorsModel>) -> Void) {
        messageStorageService.getMessages { cachedMessages in
            cacheCompletionHandler(try? cachedMessages.map { try $0.toModel() })
        }
        firebaseAppService.readAll(from: CollectionName.messages,
                                   type: MessageDTO.self) { [weak self] result in
            switch result {
                case .success(let messages):
                    self?.messageStorageService.deleteMessages { result in
                        switch result {
                            case .success:
                                self?.messageStorageService.saveMessages(messages)
                            case .failure(let error):
                                completionHandler(.failure(error.toModel()))
                        }
                    }
                do {
                    completionHandler(.success(try messages.map { try $0.toModel() }.sorted { $0.createdAt < $1.createdAt }))
                } catch {
                    completionHandler(.failure(.init(type: .general)))
                }
                case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
    }
}

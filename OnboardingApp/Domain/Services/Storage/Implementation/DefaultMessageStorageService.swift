//
//  DefaultMessageStorageService.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/04/02.
//

import RealmSwift
import Foundation

final class DefaultMessageStorageService {
    // MARK: Private properties
    private let configuration: Realm.Configuration
    private var realm: Realm {
        guard let realm = try? Realm(configuration: configuration) else {
            fatalError("Failed to initialize Realm.")
        }
        return realm
    }

    // MARK: Lifecycle functions
    init(configuration: Realm.Configuration = RealmStorage.config()) {
        self.configuration = configuration
    }
}

extension DefaultMessageStorageService: MessageStorageService {
    func saveMessages(_ messages: [MessageDTO]) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            do {
                let messageObjects = messages.map { $0.toObject() }
                try self.realm.safeWrite {
                    self.realm.add(messageObjects,
                                   update: .all)
                }
            } catch {
                print(error)
            }
        }
    }

    func getMessages(completionHandler: @escaping ([MessageDTO]) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let messages = self.realm.objects(MessageObject.self)
            completionHandler(messages.map { $0.toDTO() }.sorted { $0.createdAt < $1.createdAt })
        }
    }

    func deleteMessages(completionHandler: @escaping (Result<Void, ErrorsDTO>) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            do {
                try self.realm.safeWrite {
                    let objectsToDelete = self.realm.objects(MessageObject.self)
                    self.realm.delete(objectsToDelete)
                }
                completionHandler(.success(Void()))
            } catch {
                completionHandler(.failure(.init(type: .storage(error.localizedDescription))))
            }
        }
    }
}

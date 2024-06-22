//
//  DefaultImageStorageService.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/03/01.
//

import Foundation
import RealmSwift

final class DefaultImageStorageService {
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

extension DefaultImageStorageService: ImageStorageService {
    func saveImages(_ images: [ImageDTO]) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            do {
                let imageObjects = images.map { ImageObject(id: $0.id,
                                                            title: $0.title,
                                                            imageURLString: $0.imageURLString,
                                                            createdAt: $0.createdAt)}
                try self.realm.safeWrite {
                    self.realm.add(imageObjects,
                                   update: .all)
                }
            } catch {
                print(error)
            }
        }
    }

    func getImages(completionHandler: @escaping ([ImageDTO]) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let images = self.realm.objects(ImageObject.self)
            completionHandler(images.map { $0.toDTO() }.sorted { $0.createdAt < $1.createdAt })
        }
    }

    func deleteAllImages(completionHandler: @escaping (Result<Void, ErrorsDTO>) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            do {
                try self.realm.safeWrite {
                    let objectsToDelete = self.realm.objects(ImageObject.self)
                    self.realm.delete(objectsToDelete)
                }
                completionHandler(.success(Void()))
            } catch {
                completionHandler(.failure(.init(type: .storage(error.localizedDescription))))
            }
        }
    }
}

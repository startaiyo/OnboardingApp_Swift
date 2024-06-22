//
//  DefaultImageAppService.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/02/22.
//

final class DefaultImageAppService {
    // MARK: Private properties
    private let networkService: ImageNetworkService
    private let storageService: ImageStorageService
    private let firebaseAppService: FirebaseAppService

    init(networkService: ImageNetworkService = DefaultImageNetworkService(),
         storageService: ImageStorageService = DefaultImageStorageService(),
         firebaseAppService: FirebaseAppService = DefaultFirebaseAppService.sharedInstance) {
        self.networkService = networkService
        self.storageService = storageService
        self.firebaseAppService = firebaseAppService
    }
}

// MARK: - ImageAppService
extension DefaultImageAppService: ImageAppService {
    func getImages(_ input: ImageInput,
                   cacheCompletionHandler: @escaping ([ImageModel]) -> Void,
                   completionHandler: @escaping (Result<[ImageModel], ErrorsModel>) -> Void) {
        storageService.getImages { cachedImages in
            cacheCompletionHandler(cachedImages.map { $0.toModel() })
        }
        networkService.getImages(input) { [weak self] result in
            switch result {
                case .success(let images):
                    self?.storageService.deleteAllImages { result in
                        switch result {
                            case .success:
                                self?.storageService.saveImages(images.map { .init(id: $0.id,
                                                                                   title: $0.title,
                                                                                   imageURLString: $0.urls.raw,
                                                                                   createdAt: $0.createdAt) })
                            case .failure(let error):
                                completionHandler(.failure(error.toModel()))
                        }
                    }
                    completionHandler(.success(images.map { $0.toModel() }.sorted { $0.createdAt < $1.createdAt }))
                case .failure(let error):
                    completionHandler(.failure(error.toModel()))
                    self?.storageService.getImages { cacheImages in
                        completionHandler(.success(cacheImages.map { $0.toModel() }))
                    }
            }
        }
    }

    func saveImage(_ image: ImageModel) {
        firebaseAppService.createData(to: CollectionName.images,
                                      of: image.id,
                                      data: ["id": image.id,
                                             "title": image.title,
                                             "imageURLString": image.imageURLString,
                                             "createdAt": image.createdAt])
    }

    func getAllImages(completionHandler: @escaping (Result<[ImageModel], ErrorsModel>) -> Void) {
        firebaseAppService.readAll(from: CollectionName.images,
                                   type: ImageDTO.self) { result in
            switch result {
                case .success(let images):
                    completionHandler(.success(images.map { $0.toModel() }))
                case .failure(let error):
                    completionHandler(.failure(.init(type: .server(.init(statusCode: 500,
                                                                         message: error.localizedDescription)))))
            }
        }
    }
}

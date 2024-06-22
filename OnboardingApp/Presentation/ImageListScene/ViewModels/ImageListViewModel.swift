//
//  ImageListViewModel.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/02/07.
//

import Reachability

protocol ImageListViewModelCoordinations: AnyObject {
    func imageListViewModel(_ viewModel: ImageListViewModelProtocol,
                            didRequestToSendMessageWith cellViewModel: ImageListCellViewModel)
    func imageListViewModelDidRequestToUserSettingScene(_ viewModel: ImageListViewModelProtocol)
}

protocol ImageListViewModelInput {
    func search(_ text: String)
    func showSendConfirmation(withCellViewModel cellViewModel: ImageListCellViewModel)
    func sendMessage(with cellViewModel: ImageListCellViewModel)
    func showUserSetting()
}

protocol ImageListViewModelOutput {
    var imageListCellViewModelsSubject: AsyncStream<[ImageListCellViewModel]> { get }
    var errorsSubject: AsyncStream<ErrorsModel> { get }
    var showSendConfirmationSubject: AsyncStream<ImageListSceneImageMessageData> { get }
}

typealias ImageListViewModelProtocol = ImageListViewModelOutput & ImageListViewModelInput

extension ImageListViewModel {
    struct Input {
        let imageAppService: ImageAppService
    }
}

final class ImageListViewModel {
    // MARK: Public properties
    weak var coordinationDelegate: ImageListViewModelCoordinations?

    // MARK: Private properties
    private let input: Input
    private let reachability = try! Reachability()
    private var data = [ImageListCellViewModel]()
    private var imagesHandler: (([ImageListCellViewModel]) -> Void)?
    private var errorsHandler: ((ErrorsModel) -> Void)?
    private var showSendConfirmationHandler: ((ImageListSceneImageMessageData) -> Void)?

    init(input: Input) {
        self.input = input
    }
}

// MARK: - Private functions
private extension ImageListViewModel {
    func makeCellViewModel(_ model: ImageModel) -> ImageListCellViewModel {
        .init(input: .init(image: model))
    }
}

// MARK: - ImageListViewModelOutput
extension ImageListViewModel: ImageListViewModelOutput {
    var imageListCellViewModelsSubject: AsyncStream<[ImageListCellViewModel]> {
        return AsyncStream { continuation in
            imagesHandler = { images in
                continuation.yield(images)
            }
        }
    }

    var errorsSubject: AsyncStream<ErrorsModel> {
        return AsyncStream { continuation in
            errorsHandler = { error in
                continuation.yield(error)
            }
        }
    }

    var showSendConfirmationSubject: AsyncStream<ImageListSceneImageMessageData> {
        return AsyncStream { continuation in
            showSendConfirmationHandler = { messageData in
                continuation.yield(messageData)
            }
        }
    }
}

// MARK: - ImageListViewModelInput
extension ImageListViewModel: ImageListViewModelInput {
    func search(_ text: String) {
        var images: [ImageListCellViewModel]?
        input.imageAppService.getImages(.init(searchQuery: text),
                                        cacheCompletionHandler: { [weak self] cached in
            guard let self else { return }
            images = cached.map { self.makeCellViewModel($0) }
        }) { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let remoteImages):
                    images = remoteImages.map{ self.makeCellViewModel($0)}
                case .failure(let error):
                    if reachability.connection == .unavailable {
                        self.errorsHandler?(.init(type: .network(.noInternetConnection)))
                        return
                    }
                    self.errorsHandler?(error)
            }
            self.imagesHandler?(images ?? [])
        }
    }

    func showSendConfirmation(withCellViewModel cellViewModel: ImageListCellViewModel) {
        showSendConfirmationHandler?(.init(confirmationMessage: "The image with title \(cellViewModel.title) will be sent.",
                                           cellViewModel: cellViewModel))
    }

    func sendMessage(with cellViewModel: ImageListCellViewModel) {
        coordinationDelegate?.imageListViewModel(self,
                                                 didRequestToSendMessageWith: cellViewModel)
    }

    func showUserSetting() {
        coordinationDelegate?.imageListViewModelDidRequestToUserSettingScene(self)
    }
}

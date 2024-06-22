//
//  ImageListViewController.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/02/04.
//

import UIKit

final class ImageListViewController: UIViewController {
    // MARK: Public properties
    var viewModel: ImageListViewModel!

    // MARK: Private properties
    @IBOutlet private var imageCollectionView: UICollectionView! {
        didSet {
            imageCollectionView.register(UINib(nibName: "ImageListCell",
                                               bundle: nil),
                                         forCellWithReuseIdentifier: "ImageListCell")
            imageCollectionView.collectionViewLayout = collectionViewLayout
            imageCollectionView.delegate = self
        }
    }
    @IBOutlet private var searchBar: UISearchBar! {
        didSet {
            searchBar.backgroundColor = .yellow
            searchBar.layer.borderColor = UIColor.yellow.cgColor
            searchBar.searchBarStyle = .minimal
            searchBar.delegate = self
        }
    }
    private var imagesTask: Task<Void, Never>?
    private var errorsTask: Task<Void, Never>?
    private var showSendConfirmationTask: Task<Void, Never>?
    private lazy var dataSource = ImageDataSource(imageCollectionView)
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let margin: CGFloat = 15
        let spacing: CGFloat = 10
        let itemHeight: CGFloat = 125
        let screenWidth = UIScreen.main.bounds.width
        let itemsPerRow: CGFloat = 3
        let totalMargin = margin * 2
        let totalSpacing = spacing * (itemsPerRow - 1)
        let itemWidth: CGFloat = (screenWidth - totalMargin - totalSpacing) / itemsPerRow

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: itemWidth,
                                 height: itemHeight)
        layout.sectionInset = UIEdgeInsets(top: margin,
                                           left: margin,
                                           bottom: margin,
                                           right: margin)
        return layout
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "Image List"
        setupBindings()
    }

    deinit {
        imagesTask?.cancel()
        errorsTask?.cancel()
        showSendConfirmationTask?.cancel()
    }
}

private extension ImageListViewController {
    func setupBindings() {
        imagesTask = Task { @MainActor [weak self] in
            guard let self else { return }
            for await items in self.viewModel.imageListCellViewModelsSubject {
                self.dataSource.apply(items)
            }
        }
        errorsTask = Task { @MainActor [weak self] in
            guard let self else { return }
            for await error in viewModel.errorsSubject {
                self.handleGeneralError(error)
            }
        }
        showSendConfirmationTask = Task { @MainActor [weak self] in
            guard let self else { return }
            for await confirmationMessage in viewModel.showSendConfirmationSubject {
                self.showSendConfirmation(confirmationMessage)
            }
        }
        setUserSettingButton()
    }

    func showSendConfirmation(_ data: ImageListSceneImageMessageData) {
        let alert = UIAlertController(title: "Would you like to send it?",
                                      message: data.confirmationMessage,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "cancel",
                                         style: .cancel)
        alert.addAction(cancelAction)
        let sendAction = UIAlertAction(title: "OK",
                                       style: .default) { [weak self] _ in
            self?.viewModel.sendMessage(with: data.cellViewModel)
        }
        alert.addAction(sendAction)
        self.present(alert,
                     animated: true)
    }

    func setUserSettingButton() {
        let settingButton = UIButton()
        settingButton.setImage(UIImage(systemName: "person.circle"),
                               for: .normal)
        settingButton.tintColor = .black
        settingButton.addAction(.init(handler: { [weak self] _ in
            self?.viewModel.showUserSetting()
        }),
                                for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: settingButton)
    }
}

extension ImageListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        self.viewModel.search(text)
    }
}

extension ImageListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, 
                        didSelectItemAt indexPath: IndexPath) {
        guard let cellViewModel = dataSource.itemIdentifier(for: indexPath) else { return }
        viewModel.showSendConfirmation(withCellViewModel: cellViewModel)
    }
}

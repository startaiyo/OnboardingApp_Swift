//
//  ViewController+Extras.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/03/19.
//

import UIKit

extension UIViewController {
    func handleGeneralError(_ error: ErrorsModel,
                            onDismissHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: error.title,
                                      message: error.description,
                                      preferredStyle: .alert)
        alert.addAction(.init(title: "OK",
                              style: .default) {_ in
            onDismissHandler?()
        })
        self.present(alert,
                     animated: true)
    }
}

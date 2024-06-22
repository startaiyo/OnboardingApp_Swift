//
//  LoginViewController.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/01/31.
//

import UIKit

final class LoginViewController: UIViewController {
    var viewModel: LoginViewModelProtocol! {
        didSet {
            setupBindings()
        }
    }

    private var showInsufficientTextTask: Task<Void, Never>?
    private var errorsTask: Task<Void, Never>?

    @IBOutlet private var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "Login"
        }
    }
    @IBOutlet private var emailField: UITextField! {
        didSet {
            emailField.placeholder = "email"
            emailField.delegate = self
        }
    }
    @IBOutlet private var passwordField: UITextField! {
        didSet {
            passwordField.placeholder = "password"
            passwordField.isSecureTextEntry = true
            passwordField.delegate = self
        }
    }
    @IBOutlet private var loginButton: UIButton! {
        didSet {
            loginButton.setTitle("Login",
                                 for: .normal)
            loginButton.addAction(.init { [weak self] _ in
                self?.viewModel.login(email: self?.emailField.text,
                                      password: self?.passwordField.text)
            },
                                  for: .touchUpInside)
        }
    }
    @IBOutlet var invalidAlartLabel: UILabel! {
        didSet {
            invalidAlartLabel.isHidden = true
            invalidAlartLabel.textColor = .red
        }
    }
    @IBOutlet var registerTextView: UITextView! {
        didSet {
            let registerText = "If you're new user, please register."
            let registerAttributedString = NSMutableAttributedString(string: registerText)
            registerAttributedString.addAttribute(.link,
                                                  value: "",
                                                  range: NSString(string: registerText).range(of: "please register"))
            registerTextView.attributedText = registerAttributedString
            registerTextView.isEditable = false
            registerTextView.delegate = self
        }
    }
}

// MARK: - Private functions
private extension LoginViewController {
    func setupBindings() {
        showInsufficientTextTask = Task { @MainActor [weak self] in
            guard let self else { return }
            for await shouldShow in viewModel.shouldShowInsufficientTextSubject {
                self.showAlert(viewModel.invalidAlertText,
                               shouldShow: shouldShow)
            }
        }
        errorsTask = Task { @MainActor [weak self] in
            guard let self else { return }
            for await error in self.viewModel.errorsSubject {
                self.handleGeneralError(error)
            }
        }
    }

    func showAlert(_ text: String,
                   shouldShow: Bool) {
        invalidAlartLabel.isHidden = !shouldShow
        invalidAlartLabel.text = text
    }
}

// MARK: - UITextViewDelegate
extension LoginViewController: UITextViewDelegate {
    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        viewModel.showRegisterScreen()
        return false
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

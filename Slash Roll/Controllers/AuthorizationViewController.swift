//
//  ViewController.swift
//  Slash Roll
//
//  Created by Voxar on 14.12.21.
//

import UIKit
import SnapKit


class AuthorizationViewController: SRScrollableViewController {

    //MARK: - GUI varibles

    private lazy var emailLabel: SRLabel = {
        let emailLabel = SRLabel()
        emailLabel.text = "E-mail"
        return emailLabel
    }()

    private lazy var passwordLabel: SRLabel = {
        let passwordLabel = SRLabel()
        passwordLabel.text = "Пароль"
        return passwordLabel
    }()

    private lazy var emailTextField: SRTextField = {
        let emailTextField = SRTextField()
        emailTextField.placeholder = "E-mail"
        return emailTextField
    }()

    private lazy var passwordTextField: SRTextField = {
        let passwordTextField = SRTextField()
        passwordTextField.placeholder = "Пароль"
        return passwordTextField
    }()

    private lazy var logInButton: SRButton = {
        let logInButton = SRButton()
        logInButton.configuration?.title = "Войти"
        logInButton.addTarget(self, action: #selector(logInButtonTapped), for: .touchUpInside)
        return logInButton
    }()

    private lazy var forgotPasswordButton: UIButton = {
        let forgotPasswordButton = UIButton()
        let title = NSMutableAttributedString(string: "Забыли пароль?")
        title.addAttributes([NSAttributedString.Key.underlineStyle : 1, NSAttributedString.Key.foregroundColor : SRColors.cherryColor], range: NSRange(location: 0, length: title.length))
        forgotPasswordButton.setAttributedTitle(title, for: .normal)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonDidTapped), for: .touchUpInside)
        return forgotPasswordButton
    }()

    private lazy var registerButton: UIButton = {
        let registerButton = UIButton()
        let title = NSMutableAttributedString(string: "Зарегистрироваться")
        title.addAttributes([NSAttributedString.Key.foregroundColor: SRColors.cherryColor], range: NSRange(location: 0, length: title.length))
        registerButton.setAttributedTitle(title, for: .normal)
        registerButton.addTarget(self, action: #selector(registerButtonDidTap), for: .touchUpInside)
        return registerButton
    }()

    //MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SRColors.whiteColor
        addSubviews()
        cofigureLayout()
        addKeyboardListener()


    }

    private func addSubviews() {
        self.contentView.addSubview(emailTextField)
        self.contentView.addSubview(passwordTextField)
        self.contentView.addSubview(logInButton)
        self.contentView.addSubview(forgotPasswordButton)
        self.contentView.addSubview(registerButton)
    }

    //MARK: - Layout Cofiguration

    private func cofigureLayout() {

        self.emailTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        self.passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        self.logInButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(8)

        }

        self.forgotPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(logInButton.snp.bottom).offset(8)
            make.centerX.equalTo(contentView.snp.centerX)
        }

        self.registerButton.snp.makeConstraints { make in
            make.top.equalTo(forgotPasswordButton.snp.bottom).offset(8)
            make.centerX.equalTo(contentView.snp.centerX)
            make.bottom.equalToSuperview().inset(20)
        }
    }

    //MARK: - User Interaction

    private func addKeyboardListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }

    @objc func keyboardWillShow(notification: Notification) {

        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        scrollView.contentInset.bottom = keyboardFrame.height
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardFrame.height
        scrollView.scrollRectToVisible(registerButton.frame.insetBy(dx: -8, dy: -8), animated: false)
        scrollView.keyboardDismissMode = .interactive
    }

    @objc private func logInButtonTapped() {
        print("Залогиниться")
    }

    @objc private func forgotPasswordButtonDidTapped() {
        print("Забыли пароль")
    }

    @objc private func registerButtonDidTap() {
        print("Зарегистрироваться")
    }
}


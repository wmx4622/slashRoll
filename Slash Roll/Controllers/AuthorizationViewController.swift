//
//  ViewController.swift
//  Slash Roll
//
//  Created by Voxar on 14.12.21.
//

import UIKit
import SnapKit


class AuthorizationViewController: SRScrollableViewController {

    //MARK: - GUI variables

    private lazy var emailTextField: SRTextField = {
        let emailTextField = SRTextField()
        emailTextField.placeholder = "E-mail"
        emailTextField.returnKeyType = .next
        emailTextField.keyboardType = .emailAddress
        return emailTextField
    }()

    private lazy var passwordTextField: SRTextField = {
        let passwordTextField = SRTextField()
        passwordTextField.placeholder = "Пароль"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.returnKeyType = .join
        return passwordTextField
    }()

    private lazy var logInButton: SRButton = {
        let logInButton = SRButton()
        logInButton.configuration?.title = "Войти"
        logInButton.addTarget(self, action: #selector(logInButtonDidTapped), for: .touchUpInside)
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
        addKeyboardListener(lastViewFrame: registerButton.frame)
    }

    private func addSubviews() {
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(logInButton)
        contentView.addSubview(forgotPasswordButton)
        contentView.addSubview(registerButton)
    }

    //MARK: - Layout Cofiguration

    private func cofigureLayout() {

        emailTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        logInButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(8)

        }

        forgotPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(logInButton.snp.bottom).offset(8)
            make.centerX.equalTo(contentView.snp.centerX)
        }

        registerButton.snp.makeConstraints { make in
            make.top.equalTo(forgotPasswordButton.snp.bottom).offset(8)
            make.centerX.equalTo(contentView.snp.centerX)
            make.bottom.equalToSuperview().inset(20)
        }
    }

    //MARK: - User Interaction

    @objc private func logInButtonDidTapped() {
        
    }

    @objc private func forgotPasswordButtonDidTapped() {
        navigationController?.pushViewController(RestorePasswordViewController(), animated: true)
    }

    @objc private func registerButtonDidTap() {
        navigationController?.pushViewController(RegistrationViewController(), animated: true)
    }

}

//MARK: - Delegates

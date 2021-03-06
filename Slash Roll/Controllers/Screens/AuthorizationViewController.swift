//
//  ViewController.swift
//  Slash Roll
//
//  Created by Voxar on 14.12.21.
//

import UIKit
import SnapKit
import FirebaseAuth


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
        finishLogging()
    }

    @objc private func forgotPasswordButtonDidTapped() {
        if let navigationController = navigationController {
            navigationController.pushViewController(RestorePasswordViewController(), animated: true)
        } else {
            present(RestorePasswordViewController(), animated: true)
        }
    }

    @objc private func registerButtonDidTap() {
        if let navigationController = navigationController {
        navigationController.pushViewController(RegistrationViewController(), animated: true)
        } else {
            present(RegistrationViewController(), animated: true, completion: nil)
        }
    }


    //MARK: - Authorization

    private func finishLogging() {
        guard isLoggingInformationValid(),
              let email = emailTextField.text,
              let password = passwordTextField.text else { return }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.showAlert(title: "Ошибка", message: error.localizedDescription)
            }

            if let _ = authResult {
                self?.dismiss(animated: true, completion: nil)

                guard let scene = UIApplication.shared.connectedScenes.first,
                      let sceneDelegate = scene.delegate as? SceneDelegate else { return }
                sceneDelegate.configureTabBarTabs()
            }
        }
    }

    private func isLoggingInformationValid() -> Bool {
        guard let email = emailTextField.text else { return false }

        if !email.isEmailValid() {
            showAlert(title: "Ошибка", message: "Неверный формат e-mail адреса")
            return false
        }

        return true
    }

}

//MARK: - Delegates

extension AuthorizationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()

        case passwordTextField:
            logInButtonDidTapped()
            
        default:
            break
        }

        return true
    }
}

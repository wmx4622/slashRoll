//
//  RegistrationViewController.swift
//  Slash Roll
//
//  Created by Voxar on 19.12.21.
//

import UIKit
import Firebase
import SnapKit


class RegistrationViewController: SRScrollableViewController {

    //MARK: - GUI variables

    private lazy var nameTextField: SRTextField = {
        let nameTextField = SRTextField()
        nameTextField.placeholder = "Имя"
        nameTextField.returnKeyType = .next
        nameTextField.delegate = self
        return nameTextField
    }()

    private lazy var surnameTextField: SRTextField = {
        let surnameTextField = SRTextField()
        surnameTextField.placeholder = "Фамилия"
        surnameTextField.returnKeyType = .next
        surnameTextField.delegate = self
        return surnameTextField
    }()

    private lazy var emailTextField: SRTextField = {
        let emailTextField = SRTextField()
        emailTextField.placeholder = "E-mail"
        emailTextField.returnKeyType = .next
        emailTextField.delegate = self
        return emailTextField
    }()

    private lazy var passwordTextField: SRTextField = {
        let passwordTextField = SRTextField()
        passwordTextField.placeholder = "Пароль"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.returnKeyType = .next
        passwordTextField.delegate = self
        return passwordTextField
    }()

    private lazy var confirmPasswordTextField: SRTextField = {
        let confirmPasswordTextField = SRTextField()
        confirmPasswordTextField.placeholder = "Подтвердите пароль"
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.returnKeyType = .join
        confirmPasswordTextField.delegate = self
        return confirmPasswordTextField
    }()

    private lazy var registrationButton: SRButton = {
        let registrationButton = SRButton()
        registrationButton.configuration?.title = "Зарегистривоваться"
        registrationButton.addTarget(self, action: #selector(registerButtonDidTapped), for: .touchUpInside)
        return registrationButton
    }()

    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SRColors.whiteColor
        addSubviews()
        configureLayout()
        addKeyboardListener(lastViewFrame: registrationButton.frame)
    }

    private func addSubviews() {
        contentView.addSubview(nameTextField)
        contentView.addSubview(surnameTextField)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(confirmPasswordTextField)
        contentView.addSubview(registrationButton)
    }

    //MARK: - Layout Configuration

    private func configureLayout() {
        nameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        surnameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(surnameTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        registrationButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    //MARK: - User Interaction

    @objc private func registerButtonDidTapped() {
        finishRegistation()
    }

    private func finishRegistation() {
        guard isRegistrationInformationValid(),
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let name = nameTextField.text,
              let surname = surnameTextField.text else { return }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (createUserResult, error) in
            if let error = error {
                self?.showAlert(title: "Ошибка", message: error.localizedDescription)
            } else if let createUserResult = createUserResult {
                let fullName = "\(name) \(surname)"
                let changeRequest = createUserResult.user.createProfileChangeRequest()
                changeRequest.displayName = fullName
                changeRequest.commitChanges { error in
                    if let error = error {
                        self?.showAlert(title: "Ошибка", message: error.localizedDescription)
                    } else {
                        self?.showAlert(title: "Регистрация", message: "Регистрация прошла успешно")
                    }
                }
            }
        }
    }

    //MARK: - Validate Sign Up Information

    private func isRegistrationInformationValid() -> Bool {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text else { return false }

        if !email.isEmailValid() {
            showAlert(title: "Ошибка", message: "Неверный формат e-mail адреса")
            return false
        }

        if !password.isPasswordValid() {
            showAlert(title: "Ошибка", message: "Пароль должен содержать от 8 знаков только латинского алфавита, одну большую букву и спецсимвол")
            return false
        }

        if password != confirmPassword {
            showAlert(title: "Ошибка", message: "Пароли не совпадают")
            return false
        }

        return true
    }
}

//MARK: - Delegates

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            surnameTextField.becomeFirstResponder()

        case surnameTextField:
            emailTextField.becomeFirstResponder()

        case emailTextField:
            passwordTextField.becomeFirstResponder()

        case passwordTextField:
            confirmPasswordTextField.becomeFirstResponder()

        case confirmPasswordTextField:
            finishRegistation()

        default:
            break
        }

        return true
    }
}

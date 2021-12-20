//
//  RegistrationViewController.swift
//  Slash Roll
//
//  Created by Voxar on 19.12.21.
//

import UIKit
import Firebase

class RegistrationViewController: SRScrollableViewController {

    //MARK: - GUI varibles

    private lazy var nameTextField: SRTextField = {
        let nameTextField = SRTextField()
        nameTextField.placeholder = "Имя"
        return nameTextField
    }()

    private lazy var surnameTextField: SRTextField = {
        let surnameTextField = SRTextField()
        surnameTextField.placeholder = "Фамилия"
        return surnameTextField
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

    private lazy var confirmPasswordTextField: SRTextField = {
        let confirmPasswordTextField = SRTextField()
        confirmPasswordTextField.placeholder = "Подтвердите пароль"
        return confirmPasswordTextField
    }()

    private lazy var registrationButton: SRButton = {
        let registrationButton = SRButton()
        registrationButton.configuration?.title = "Зарегистривоваться"
        registrationButton.addTarget(self, action: #selector(registrationButtonTapped), for: .touchUpInside)
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
        self.nameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        self.surnameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        self.emailTextField.snp.makeConstraints { make in
            make.top.equalTo(surnameTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        self.passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        self.confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        self.registrationButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    //MARK: - User Interaction

    @objc private func registrationButtonTapped() {
        guard isRegistrationInformationValid(),
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let name = nameTextField.text,
              let surname = surnameTextField.text else { return }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (createUserResult, error) in
            if let error = error {
                self?.showAlert(title: "Ошибка", message: error.localizedDescription)
            } else if let createUserResult = createUserResult {
                let fullname = "\(name) \(surname)"
                let changeRequest = createUserResult.user.createProfileChangeRequest()
                changeRequest.displayName = fullname
                changeRequest.commitChanges { error in
                    if let error = error {
                        self?.showAlert(title: "Ошибка", message: error.localizedDescription)
                    }
                }
            }
        }
    }

    //MARK: - Validate Sign In Information

    private func isRegistrationInformationValid() -> Bool {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text else { return false }

        if !email.isEmailValid() {
            showAlert(title: "Ошибка", message: "Неверный формат e-mail адреса")
            return false
        }

        if !password.isPasswordValid() {
            showAlert(title: "Ошибка", message: "Пароль должен содержать от 8 знаков латинского алфавита, одну большую букву и спецсимвол")
            return false
        }

        if password != confirmPassword {
            showAlert(title: "Ошибка", message: "Пароли не совпадают")
            return false
        }

        return true
    }
}

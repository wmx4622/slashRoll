//
//  RegistrationViewController.swift
//  Slash Roll
//
//  Created by Voxar on 19.12.21.
//

import UIKit


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
        registrationButton.addTarget(self, action: #selector(finishRegistration), for: .touchUpInside)
        return registrationButton
    }()

    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SRColors.whiteColor
        addSubviews()
        configureLayout()
        addKeyboardListener()
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
        scrollView.scrollRectToVisible(registrationButton.frame.insetBy(dx: -8, dy: -8), animated: false)
        scrollView.keyboardDismissMode = .interactive
    }

    @objc private func finishRegistration() {
        print("Закончить регистрацию")
    }
}

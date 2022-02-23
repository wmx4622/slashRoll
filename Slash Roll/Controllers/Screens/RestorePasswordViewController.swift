//
//  RestorePasswordViewController.swift
//  Slash Roll
//
//  Created by Voxar on 21.12.21.
//

import UIKit
import Firebase
import SnapKit


class RestorePasswordViewController : SRScrollableViewController {

    //MARK: - GUI variables

    private lazy var emailTextField: SRTextField = {
        let emailTextField = SRTextField()
        emailTextField.placeholder = "E-mail"
        emailTextField.returnKeyType = .continue
        emailTextField.delegate = self
        return emailTextField
    }()

    private lazy var restorePasswordButton: SRButton = {
        let restorePasswordButton = SRButton()
        restorePasswordButton.configuration?.title = "Восстановить пароль"
        restorePasswordButton.addTarget(self, action: #selector(restorePasswordButtonDidTapped), for: .touchUpInside)
        return restorePasswordButton
    }()

    //MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SRColors.whiteColor
        addSubviews()
        configureLayout()
        addKeyboardListener(lastViewFrame: restorePasswordButton.frame)

    }

    private func addSubviews() {
        contentView.addSubview(emailTextField)
        contentView.addSubview(restorePasswordButton)
    }

    //MARK: - Layout Configuration

    private func configureLayout() {
        emailTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        restorePasswordButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(20)
        }
    }

    //MARK: - User Interaction

    @objc private func restorePasswordButtonDidTapped() {
        restorePassword()
    }

    private func restorePassword() {
        guard let email = emailTextField.text else { return }
        guard email.isEmailValid() else {
            showAlert(title: "Ошибка", message: "Неверный формат e-mail")
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Ошибка", message: error.localizedDescription)
            } else {
                self?.showAlert(title: "Смена пароля", message: "Письмо с инструкцией по изменению пароля отправлено на электронную почту")
            }
        }
    }
}

//MARK: - Delegates

extension RestorePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            restorePassword()
        }

        return true
    }
}

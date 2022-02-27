//
//  SettingsViewController.swift
//  Slash Roll
//
//  Created by Voxar on 27.02.22.
//

import UIKit
import Firebase


class SettingsViewController: SRScrollableViewController {

    //MARK: - GUI Variables

    private lazy var changeNameButton: TitledDecoratedButton = {
        let changeNameButton = TitledDecoratedButton(title: "Изменить имя", image: UIImage(systemName: "mail"), frame: .zero)
        changeNameButton.addTarget(self, action: #selector(changeUserNameButtonDidTapped), for: .touchUpInside)
        return changeNameButton
    }()

    private lazy var changePasswordButton: TitledDecoratedButton = {
        let changePasswordButton = TitledDecoratedButton(title: "Изменить пароль", image: UIImage(systemName: "key"), frame: .zero)
        changePasswordButton.addTarget(self, action: #selector(changePasswordButtonDidTapped), for: .touchUpInside)
        return changePasswordButton
    }()

    private lazy var changeEmailButton: TitledDecoratedButton = {
        let changeEmailButton = TitledDecoratedButton(title: "Изменить почту", image: UIImage(systemName: "envelope.badge.shield.half.filled"), frame: .zero)
        changeEmailButton.addTarget(self, action: #selector(changeEmailButtonDidTapped), for: .touchUpInside)
        return changeEmailButton
    }()

    private lazy var changeAddressButton: TitledDecoratedButton = {
        let changeAddressButton = TitledDecoratedButton(title: "Изменить адресс", image: UIImage(systemName: "house"), frame: .zero)
        changeAddressButton.addTarget(self, action: #selector(changeUserAddressButtonDidTapped), for: .touchUpInside)
        return changeAddressButton
    }()

    private lazy var settingsStackView: UIStackView = {
        let settingsStackView = UIStackView()
        settingsStackView.axis = .vertical
        settingsStackView.spacing = 8
        settingsStackView.alignment = .leading
        settingsStackView.addArrangedSubview(changeNameButton)
        settingsStackView.addArrangedSubview(changePasswordButton)
        settingsStackView.addArrangedSubview(changeEmailButton)
        settingsStackView.addArrangedSubview(changeAddressButton)

        return settingsStackView
    }()

    //MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureLayout()
        configureControllerAppearance()
    }

    private func addSubviews() {
        contentView.addSubview(settingsStackView)
    }

    private func configureControllerAppearance() {
        title = "Настройки"

        let textAttributes = [NSAttributedString.Key.foregroundColor: SRColors.cherryColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        view.backgroundColor = SRColors.whiteColor
        navigationController?.navigationBar.barTintColor = SRColors.cherryLightColor
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    //MARK: - Layout Configuration

    private func configureLayout() {
        settingsStackView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(8)

        }
    }

    //MARK: - User Interaction

    @objc private func changeUserNameButtonDidTapped() {
        changeUserName()
    }

    @objc private func changeUserAddressButtonDidTapped() {
    }

    @objc private func changeEmailButtonDidTapped() {
        changeUserEmail()
    }

    @objc private func changePasswordButtonDidTapped() {
        changeUserPassword()
    }

    //MARK: - Account Data Mangment

    private func changeUserName() {
        let alert = UIAlertController(title: "", message: "Изменить имя пользователя", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Новое имя"
        }

        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { [weak alert] _ in
            guard let textfield = alert?.textFields?[0], let newUsername = textfield.text else { return }
            guard let user = Auth.auth().currentUser else { return }
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = newUsername
            changeRequest.commitChanges { [weak self] error in
                guard let self = self else { return }

                if let error = error {
                    self.showAlert(title: "Ошибка", message: error.localizedDescription)
                } else {
                    self.showAlert(title: "", message: "Имя успешно изменёно.")
                }
            }
        }))

        self.present(alert, animated: true, completion: nil)
    }

    private func changeUserEmail() {

        let alert = UIAlertController(title: "", message: "Изменить e-mail", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Новый e-mail"
            textField.keyboardType = .emailAddress
            textField.autocorrectionType = .no
        }

        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { [weak alert] _ in
            guard let textfield = alert?.textFields?[0], let newEmail = textfield.text else { return }

            if !newEmail.isEmailValid() {
                self.showAlert(title: "Ошибка", message: "Введен неправильный e-mail")
            } else {
                guard let user = Auth.auth().currentUser else { return }
                user.updateEmail(to: newEmail, completion: { [weak self] error in
                    guard let self = self else { return }

                    if let error = error {
                        self.showAlert(title: "Ошибка", message: error.localizedDescription)
                    } else {
                        self.showAlert(title: "", message: "Ваш email успешно изменён.")
                    }
                })
            }
        }))

        self.present(alert, animated: true, completion: nil)
    }

    private func changeUserPassword() {

        let alert = UIAlertController(title: "", message: "Введите новый пароль", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Новый пароль"
            textField.isSecureTextEntry = true
        }
        alert.addTextField { (textFieldPass) in
            textFieldPass.placeholder = "Повторите пароль"
            textFieldPass.isSecureTextEntry = true
        }

        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { [weak alert] _ in
            guard let newPassword = alert?.textFields?[0].text, let repeatPassword = alert?.textFields?[1].text else { return }

            if !newPassword.isPasswordValid() {
                self.showAlert(title: "Ошибка", message: "Пароль должен содержать от 8 знаков только латинского алфавита, одну большую букву и спецсимвол")
            } else if newPassword != repeatPassword {
                self.showAlert(title: "Ошибка", message: "Пароль и его подтверждение должны совпадать")
            } else {
                guard let user = Auth.auth().currentUser else { return }
                user.updatePassword(to: newPassword, completion: { [weak self] error in
                    guard let self = self else { return }

                    if let error = error {
                        self.showAlert(title: "Ошибка", message: error.localizedDescription)
                    } else {
                        self.showAlert(title: "", message: "Ваш пароль успешно изменён")
                    }
                })
            }
        }))

        self.present(alert, animated: true, completion: nil)
    }


}

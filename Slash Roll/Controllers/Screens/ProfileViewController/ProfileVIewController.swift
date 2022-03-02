//
//  ProfileVIewController.swift
//  Slash Roll
//
//  Created by Voxar on 26.02.22.
//

import UIKit
import Firebase


class ProfileViewController: SRScrollableViewController {

    //MARK: - Properties

    private let avatarImageSize: CGSize = CGSize(width: 80, height: 80)

    //MARK: - GUI Varibles

    private lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.image = UIImage(systemName: "umbrella")
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.layer.cornerRadius = avatarImageSize.height / 2
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = SRColors.cherryLightColor.cgColor
        return avatarImageView
    }()

    private lazy var nameLabel: SRLabel = {
        let nameLabel = SRLabel()
        nameLabel.text = "Имя"
        return nameLabel
    }()

    private lazy var emailLabel: SRLabel = {
        let emailLabel = SRLabel()
        emailLabel.text = "email"
        return emailLabel
    }()

    private lazy var nameEmailStackView: UIStackView = {
        let nameEmailStackView = UIStackView()
        nameEmailStackView.axis = .vertical
        nameEmailStackView.spacing = 8
        nameEmailStackView.addArrangedSubview(nameLabel)
        nameEmailStackView.addArrangedSubview(emailLabel)
        return nameEmailStackView
    }()

    private lazy var userAddressStackView: UIStackView = {
        let userAddressStackView = UIStackView()
        userAddressStackView.axis = .horizontal
        userAddressStackView.spacing = 8
        return userAddressStackView
    }()

    private lazy var settingsButton: TitledDecoratedButton = {
        let settingsButton = TitledDecoratedButton(title: "Настройки", image: UIImage(systemName: "gear"), frame: .zero)
        settingsButton.addTarget(self, action: #selector(settingsButtonDidTapped), for: .touchUpInside)
        return settingsButton
    }()

    private lazy var logoutButton: TitledDecoratedButton = {
        let logoutButton = TitledDecoratedButton(title: "Выйти", image: UIImage(systemName: "arrowshape.turn.up.backward"), frame: .zero)
        logoutButton.addTarget(self, action: #selector(logOutButtonDidTapped), for: .touchUpInside)
        return logoutButton
    }()

    private lazy var menuStackView: UIStackView = {
        let menuStackView = UIStackView()
        menuStackView.axis = .vertical
        menuStackView.spacing = 8
        menuStackView.addArrangedSubview(settingsButton)
        menuStackView.addArrangedSubview(logoutButton)
        menuStackView.alignment = .leading
        return menuStackView
    }()

    //MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureLayout()
        configureControllerAppearance()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
    }

    private func configureControllerAppearance() {
        title = "Профиль"

        let textAttributes = [NSAttributedString.Key.foregroundColor: SRColors.cherryColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        view.backgroundColor = SRColors.whiteColor
        navigationController?.navigationBar.barTintColor = SRColors.cherryLightColor
        navigationItem.hidesSearchBarWhenScrolling = false
    }


    private func addSubviews() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameEmailStackView)
        contentView.addSubview(menuStackView)
    }

    //MARK: - Layout Configuration

    private func configureLayout() {

        avatarImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(8)
            make.height.width.equalTo(avatarImageSize)
        }

        nameEmailStackView.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualToSuperview().inset(24)
            make.top.equalToSuperview().offset(8)
        }

        menuStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.top.equalTo(avatarImageView.snp.bottom).offset(16)
            make.bottom.equalToSuperview().inset(20)
        }
    }

    //MARK: - User Interaction

    @objc private func logOutButtonDidTapped() {
        logOut()
    }

    @objc private func settingsButtonDidTapped() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }

    //MARK: - Profile functions

    private func logOut() {
        do {
            try Auth.auth().signOut()
            guard let scene = UIApplication.shared.connectedScenes.first,
                  let sceneDelegate = scene.delegate as? SceneDelegate else { return }
            sceneDelegate.configureTabBarTabs()
            
        } catch let signOutError as NSError {
            showAlert(title: "Ошибка", message: signOutError.localizedDescription)
        }
    }

    private func setData() {
        emailLabel.text = Auth.auth().currentUser?.email
        nameLabel.text = Auth.auth().currentUser?.displayName
    }
}

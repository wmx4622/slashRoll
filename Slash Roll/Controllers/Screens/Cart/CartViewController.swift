//
//  CartViewController.swift
//  Slash Roll
//
//  Created by Voxar on 16.02.22.
//

import UIKit


class CartViewController: UIViewController {

    //MARK: - Properties

    private(set) lazy var tableViewDataSource = CartTableViewDataSource(callback: {
        self.showAlert(title: "Лимит товара", message: "Для закакза более 100 единиц товара свяжитесь с менджерами")
    })

    //MARK: - GUI varibles
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.dataSource = tableViewDataSource
        tableView.delegate = self
        tableView.backgroundColor = SRColors.whiteColor
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat.leastNonzeroMagnitude, height: CGFloat.leastNonzeroMagnitude))
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.reuseIdentifier)

        return tableView
    }()

    private lazy var continueCheckoutButton: SRButton = {
        let continueCheckoutButton = SRButton()
        continueCheckoutButton.configuration?.title = "Продолжить оформление заказа"
        continueCheckoutButton.addTarget(self, action: #selector(continueCheckoutButtonDidTapped), for: .touchUpInside)
        return continueCheckoutButton
    }()

    private lazy var emptyCartLabel: SRLabel = {
        let emptyCartLabel = SRLabel()
        emptyCartLabel.text = "Корзина пуста"
        emptyCartLabel.textAlignment = .center
        return emptyCartLabel
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
        tableView.reloadData()
        updateControllerState()
    }


    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(continueCheckoutButton)
    }

    private func configureControllerAppearance() {
        title = "Корзина"
        let textAttributes = [NSAttributedString.Key.foregroundColor: SRColors.cherryColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        view.backgroundColor = SRColors.whiteColor
        navigationController?.navigationBar.tintColor = SRColors.cherryColor
        navigationController?.navigationBar.barTintColor = SRColors.cherryLightColor
    }

    private func updateControllerState() {
        continueCheckoutButton.isHidden = tableViewDataSource.isCartEmpty()
        if tableViewDataSource.isCartEmpty() {
            tableView.backgroundView = emptyCartLabel
            setEmptyCartLabelPosition()
        } else {
            tableView.backgroundView = nil
        }
    }

    //MARK: - Layout Configuration
    
    private func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.width.height.leading.trailing.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        continueCheckoutButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(tableView.snp.bottom).inset(continueCheckoutButton.frame.height + 8)
        }
    }

    private func setEmptyCartLabelPosition() {
        emptyCartLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    //MARK: - User Interation

    @objc private func continueCheckoutButtonDidTapped() {
        let formOrderController = FormOrderController(orderedProducts: tableViewDataSource.getAllOrderedProducts())
        present(formOrderController, animated: true, completion: nil)
    }
}

//MARK: - Delegates

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        122
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productDetailsViewController = ProductDetaisViewController()
        productDetailsViewController.shownProduct = tableViewDataSource.getProduct(with: indexPath.row).product
        navigationController?.pushViewController(productDetailsViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(
            actions:
                [
                    UIContextualAction(
                        style: .destructive, title: "Удалить", handler: { _, _, complition in
                            complition(true)
                            self.tableViewDataSource.deleteProduct(with: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .automatic)
                            self.updateControllerState()
                            if self.tableViewDataSource.getProductCount() > 0 {
                                self.tabBarController?.tabBar.items?[TabBarTabs.cart.rawValue].badgeValue = "\(self.tableViewDataSource.getProductCount())"
                            } else {
                                self.tabBarController?.tabBar.items?[TabBarTabs.cart.rawValue].badgeValue = nil
                            }
                        }
                    )
                ]
        )
    }
}

//
//  CartViewController.swift
//  Slash Roll
//
//  Created by Voxar on 16.02.22.
//

import UIKit


class CartViewController: UIViewController {

    //MARK: - Properties

    private lazy var tableViewDataSource = CartTableViewDataSource()

    //MARK: - GUI varibles
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.dataSource = tableViewDataSource
        tableView.backgroundColor = SRColors.whiteColor
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat.leastNonzeroMagnitude, height: CGFloat.leastNonzeroMagnitude))

        return tableView
    }()

    private lazy var continueCheckoutButton: SRButton = {
        let continueCheckoutButton = SRButton()
        continueCheckoutButton.configuration?.title = "Продолжить оформление заказа"
        return continueCheckoutButton
    }()

    //MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureLayout()
    }

    private func addSubviews() {
        view.addSubview(tableView)
    }

    //MARK: - Layout Configuration
    
    private func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.width.height.leading.trailing.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

//
//  CatalogController.swift
//  Slash Roll
//
//  Created by Voxar on 4.02.22.
//

import UIKit


class CatalogController: UIViewController, UITableViewDelegate {


    private lazy var tableViewDataSource = CatalogTableViewDataSource()

    //MARK: - GUI varibles

    private lazy var testTextField: SRTextField = {
        let testTextField = SRTextField()
        return testTextField
    }()

    private lazy var tableView: SRTableView = {
        let tableView = SRTableView()
        tableView.dataSource = tableViewDataSource
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        return tableView
    }()

    //MARK: - Layout Configuration

    private func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.width.height.equalTo(view.safeAreaLayoutGuide)

        }

        testTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.trailing.leading.equalToSuperview().inset(8)
        }

        tableView.setContentOffset(CGPoint(x: 0, y: -60), animated: true)
        tableView.contentInset.top = 60
    }

    //MARK: View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureLayout()
        view.backgroundColor = .white
        
    }

    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(testTextField)
    }
}

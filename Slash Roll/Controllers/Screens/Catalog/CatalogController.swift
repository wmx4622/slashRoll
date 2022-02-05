//
//  CatalogController.swift
//  Slash Roll
//
//  Created by Voxar on 4.02.22.
//

import UIKit


class CatalogController: UIViewController {


    private lazy var tableViewDataSource = CatalogTableViewDataSource()

    //MARK: - GUI varibles

//    private lazy var testHeader: CatalogNavigationView = {
//        let testHeader = CatalogNavigationView()
//        return testHeader
//    }()

    private lazy var tableView: SRTableView = {
        let tableView = SRTableView(frame: view.frame, style: .grouped)
//        tableView.tableHeaderView = CatalogNavigationView()
        tableView.dataSource = tableViewDataSource
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        tableView.register(CatalogTableViewCell.self, forCellReuseIdentifier: CatalogTableViewCell.reuseIdentifier)
        return tableView
    }()

    private lazy var barItem: UIBarButtonItem = {
        let barItem = UIBarButtonItem(customView: CatalogNavigationView())

        return barItem
    }()

    //MARK: - Layout Configuration

    private func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.width.height.equalTo(view.safeAreaLayoutGuide)

        }

//        testHeader.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
//            make.trailing.leading.equalToSuperview().inset(8)
//        }

//        barItem.customView?.snp.makeConstraints({ make in
//            make.trailing.leading.equalTo(view).inset(8)
//        })


    }

    //MARK: View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()

        view.backgroundColor = .white

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureLayout()
    }

    private func addSubviews() {
        view.addSubview(tableView)
//        tableView.addSubview(testHeader)
//        navigationItem.leftBarButtonItem = barItem
    }
}

extension CatalogController: UITableViewDelegate {

//    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y < 16 {
//            UIView.animate(withDuration: 0.25, animations: {
//                self.tableView.contentInset.top = 16
//            })
//        } else if scrollView.contentOffset.y > testHeader.frame.size.height + 16 {
//            UIView.animate(withDuration: 0.25, animations: {
//                self.tableView.contentInset.top = -1 * self.testHeader.frame.size.height + 16
//            })
//        }

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            76
        }
}

//
//  CartViewController.swift
//  Slash Roll
//
//  Created by Voxar on 16.02.22.
//

import UIKit


class CartViewController: UIViewController {

    //MARK: - GUI varibles
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .grouped)
//        tableView.dataSource = tableViewDataSource
//        tableView.delegate = self
        tableView.backgroundColor = SRColors.whiteColor

//        tableView.register(CatalogTableViewCell.self, forCellReuseIdentifier: CatalogTableViewCell.reuseIdentifier)
//        tableView.refreshControl = refreshControll
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat.leastNonzeroMagnitude, height: CGFloat.leastNonzeroMagnitude))

        return tableView
    }()
}

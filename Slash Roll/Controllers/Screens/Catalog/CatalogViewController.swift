//
//  CatalogController.swift
//  Slash Roll
//
//  Created by Voxar on 4.02.22.
//

import UIKit
import Firebase


class CatalogViewController: UIViewController {

    //MARK: - Properties

    private lazy var tableViewDataSource = CatalogTableViewDataSource()

    //MARK: - GUI varibles

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.dataSource = tableViewDataSource
        tableView.delegate = self
        tableView.backgroundColor = SRColors.whiteColor
        tableView.register(CatalogTableViewCell.self, forCellReuseIdentifier: CatalogTableViewCell.reuseIdentifier)
        tableView.refreshControl = refreshControll
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat.leastNonzeroMagnitude, height: CGFloat.leastNonzeroMagnitude))

        return tableView
    }()

    private lazy var searchBarController: SRSearchBarController = {
        let searchBarController = SRSearchBarController(searchResultsController: nil)
        searchBarController.searchResultsUpdater = self
        searchBarController.searchBar.delegate = self
        searchBarController.searchBar.sizeToFit()
        searchBarController.searchBar.scopeButtonTitles = ["Всё", "Роллы", "Закуски"]
        searchBarController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Найдите то, что вам по душе",
            attributes: [
                NSAttributedString.Key.foregroundColor: SRColors.whiteColor
            ]
        )
        return searchBarController
    }()

    private lazy var refreshControll: UIRefreshControl = {
        let refreshControll = UIRefreshControl()
        refreshControll.addTarget(self, action: #selector(refreshControllHandler), for: .valueChanged)
        refreshControll.tintColor = SRColors.cherryLightColor
        return refreshControll
    }()

    //MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureLayout()
        configureControllerAppearance()
        tableViewDataSource.loadProductList { [weak self] in
            self?.tableView.reloadData()

        }
    }

    private func addSubviews() {
        view.addSubview(tableView)
        navigationItem.searchController = searchBarController
    }

    private func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.width.height.equalTo(view.safeAreaLayoutGuide)
        }
    }

    //MARK: - Layout Configuration

    private func configureControllerAppearance() {
        title = "Каталог"
        let textAttributes = [NSAttributedString.Key.foregroundColor: SRColors.cherryColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        view.backgroundColor = SRColors.whiteColor
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.tintColor = SRColors.cherryColor
        navigationController?.navigationBar.barTintColor = SRColors.cherryLightColor
    }

    //MARK: - User Interaction

    @objc private func refreshControllHandler() {
        tableViewDataSource.loadProductList { [weak self] in
            self?.tableView.reloadData()
            self?.refreshControll.endRefreshing()
        }
    }
}

//MARK: - Delegates

extension CatalogViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        76
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var product = tableViewDataSource.getProduct(withID: indexPath.row)

        if let cell = tableView.cellForRow(at: indexPath) as? CatalogTableViewCell {
            product.image = cell.productImage
        }

        let productDetailsViewController = ProductDetaisViewController()
        productDetailsViewController.shownProduct = product
        navigationController?.pushViewController(productDetailsViewController, animated: true)
    }
}

extension CatalogViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchedText = searchController.searchBar.text else { return }
        let scope = searchController.searchBar.selectedScopeButtonIndex
        tableViewDataSource.filterProducts(by: searchedText, productCategoryNumber: scope)
        tableView.reloadData()
    }
}

extension CatalogViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let searchedText = searchBar.text else { return }
        tableViewDataSource.filterProducts(by: searchedText, productCategoryNumber: selectedScope)
    }
}

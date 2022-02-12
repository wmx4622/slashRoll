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

    private lazy var catalogNavigationView: CatalogNavigationView = {
        let catalogNavigationView = CatalogNavigationView()
        return catalogNavigationView
    }()

    lazy var tableView: SRTableView = {
        let tableView = SRTableView(frame: view.frame, style: .grouped)
        tableView.dataSource = tableViewDataSource
        tableView.delegate = self
        tableView.backgroundColor = SRColors.whiteColor
        //        tableView.contentInset.top = catalogNavigationView.frame.size.height + 16
        //        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CatalogTableViewCell.reuseIdentifier)
        tableView.register(CatalogTableViewCell.self, forCellReuseIdentifier: CatalogTableViewCell.reuseIdentifier)
        return tableView
    }()

    private lazy var searchBarController: SRSearchBarController = {
        let searchBarController = SRSearchBarController(searchResultsController: nil)
        searchBarController.searchResultsUpdater = self
        searchBarController.searchBar.delegate = self
        searchBarController.searchBar.sizeToFit()
        searchBarController.searchBar.scopeButtonTitles = ["Всё", "Роллы", "Закуски"]
        searchBarController.searchBar.setScopeBarButtonTitleTextAttributes([NSAttributedString.Key.foregroundColor : SRColors.cherryLightColor], for: .normal)
        searchBarController.searchBar.setScopeBarButtonTitleTextAttributes([NSAttributedString.Key.foregroundColor : SRColors.cherryColor], for: .selected)
        searchBarController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Найдите то, что вам по душе",
            attributes: [
                NSAttributedString.Key.foregroundColor: SRColors.whiteColor
            ]
        )
        return searchBarController
    }()

    //MARK: - Layout Configuration

    private func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.width.height.equalTo(view.safeAreaLayoutGuide)
        }

        //        catalogNavigationView.snp.makeConstraints { make in
        //            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
        //            make.trailing.leading.equalToSuperview().inset(8)
        //        }
    }

    //MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        view.backgroundColor = SRColors.whiteColor
        tableViewDataSource.loadProductList { [weak self] in
            self?.tableView.reloadData()
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureLayout()
    }

    private func addSubviews() {
        view.addSubview(tableView)
        //        view.addSubview(catalogNavigationView)
        navigationItem.searchController = searchBarController
        navigationItem.hidesSearchBarWhenScrolling = false
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
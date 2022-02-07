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

    private lazy var catalogNavigationView: CatalogNavigationView = {
        let catalogNavigationView = CatalogNavigationView()
        return catalogNavigationView
    }()

    private lazy var tableView: SRTableView = {
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
        searchBarController.searchBar.sizeToFit()
        searchBarController.searchBar.scopeButtonTitles = ["Всё", "Роллы", "Сеты"]
        searchBarController.searchBar.setScopeBarButtonTitleTextAttributes([NSAttributedString.Key.foregroundColor : SRColors.cherryLightColor], for: .normal)
        searchBarController.searchBar.setScopeBarButtonTitleTextAttributes([NSAttributedString.Key.foregroundColor : SRColors.cherryColor], for: .selected)
        searchBarController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Найдите роллы вам по душе",
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

    //MARK: View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        view.backgroundColor = SRColors.whiteColor
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

extension CatalogController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        76
    }
}

extension CatalogController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchedText = searchController.searchBar.text else { return }
        tableViewDataSource.filterProducts(by: searchedText)
        tableView.reloadData()
    }


}

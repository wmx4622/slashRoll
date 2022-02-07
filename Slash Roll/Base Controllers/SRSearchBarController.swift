//
//  SearchBarController.swift
//  Slash Roll
//
//  Created by Voxar on 6.02.22.
//

import UIKit


class SRSearchBarController: UISearchController {
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        obscuresBackgroundDuringPresentation = false
        searchBar.searchTextField.backgroundColor = SRColors.cherryLightColor
        searchBar.searchTextField.tintColor = SRColors.whiteColor
        searchBar.searchTextField.textColor = SRColors.whiteColor

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  SearchBarController.swift
//  Slash Roll
//
//  Created by Voxar on 6.02.22.
//

import UIKit


class SRSearchBarController: UISearchController {

    //MARK: - Initialization

    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        obscuresBackgroundDuringPresentation = false
        searchBar.searchTextField.backgroundColor = SRColors.cherryLightColor
        searchBar.searchTextField.tintColor = SRColors.whiteColor
        searchBar.searchTextField.textColor = SRColors.whiteColor
        searchBar.scopeButtonTitles = []
        searchBar.setScopeBarButtonTitleTextAttributes([NSAttributedString.Key.foregroundColor : SRColors.whiteColor], for: .normal)
        searchBar.setScopeBarButtonTitleTextAttributes([NSAttributedString.Key.foregroundColor : SRColors.cherryColor], for: .selected)
        searchBar.setScopeBarButtonBackgroundImage(UIImage.getImage(from: SRColors.cherryLightColor), for: .normal)
        searchBar.setScopeBarButtonDividerImage(UIImage.getImage(from: SRColors.whiteColor), forLeftSegmentState: .normal, rightSegmentState: .highlighted)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

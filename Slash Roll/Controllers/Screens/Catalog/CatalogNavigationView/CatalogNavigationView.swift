//
//  CatalogNavigationView.swift
//  Slash Roll
//
//  Created by Voxar on 5.02.22.
//

import UIKit


class CatalogNavigationView: UIView {

    //MARK: - GUI Varibles
    
    private lazy var searchBar: SRTextField = {
        let searchBar = SRTextField()
        return searchBar
    }()

    //MARK: - UIView Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configureCatalogNavigationViewLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        self.addSubview(searchBar)

    }

    //MARK: - LayoutConfiguration

    private func configureCatalogNavigationViewLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(8)

        }


    }
}

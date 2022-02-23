//
//  SRQuantityButton.swift
//  Slash Roll
//
//  Created by Voxar on 12.02.22.
//

import UIKit

class SRQuantityButton: UIButton {

    //MARK: - Initialization

    required init(title: String) {
        super.init(frame: .zero)
        configureButtonAppearance(title: title)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Appearance Configuration
    
    private func configureButtonAppearance(title: String) {
        setAttributedTitle(NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.foregroundColor: SRColors.cherryColor,.font: UIFont.systemFont(ofSize: 30, weight: .heavy)]), for: .normal)
        self.snp.makeConstraints { make in
            make.height.width.equalTo(30)
        }
    }
}



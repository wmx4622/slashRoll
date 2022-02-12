//
//  SRButton.swift
//  Slash Roll
//
//  Created by Voxar on 15.12.21.
//

import UIKit
import SnapKit


class SRButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButtonAppearance()
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureButtonAppearance() {
        self.snp.makeConstraints { make in
            make.height.equalTo(30)
        }

        configuration = .filled()
        configuration?.baseBackgroundColor = SRColors.cherryColor
        configuration?.cornerStyle = .capsule
    }
}

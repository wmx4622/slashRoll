//
//  SRLabel.swift
//  Slash Roll
//
//  Created by Voxar on 15.12.21.
//

import UIKit
import SnapKit


class SRLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabelAppereance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLabelAppereance() {
        textColor = SRColors.cherryLightColor
        snp.makeConstraints { make in
            make.height.equalTo(30)
        }
    }
}

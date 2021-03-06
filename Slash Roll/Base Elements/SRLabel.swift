//
//  SRLabel.swift
//  Slash Roll
//
//  Created by Voxar on 15.12.21.
//

import UIKit
import SnapKit


class SRLabel: UILabel {

    //MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabelAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Appeanrance Configuration

    private func configureLabelAppearance() {
        textColor = SRColors.cherryLightColor
        snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(30)
        }
    }
}

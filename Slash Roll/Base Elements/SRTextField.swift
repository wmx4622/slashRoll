//
//  SRTextField.swift
//  Slash Roll
//
//  Created by Voxar on 15.12.21.
//

import UIKit
import SnapKit


class SRTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextFieldAppereance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureTextFieldAppereance() {
        snp.makeConstraints { make in
            make.height.equalTo(30)
        }

        backgroundColor = SRColors.cherryLightColor
        attributedPlaceholder = NSAttributedString(
            string: " ",
            attributes: [
                NSAttributedString.Key.foregroundColor:SRColors.whiteColor
            ]
        )
        borderStyle = .roundedRect
        clearButtonMode = .whileEditing
        autocorrectionType = .no
        tintColor = SRColors.whiteColor
        textColor = SRColors.whiteColor
    }
}

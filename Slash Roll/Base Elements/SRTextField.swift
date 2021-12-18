//
//  SRTextField.swift
//  Slash Roll
//
//  Created by Voxar on 15.12.21.
//

import UIKit


class SRTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextFieldAppereance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureTextFieldAppereance() {
        self.snp.makeConstraints { make in
            make.height.equalTo(30)
        }

        self.backgroundColor = SRColors.cherryLightColor
        self.borderStyle = .roundedRect
        self.clearButtonMode = .whileEditing
        self.autocorrectionType = .no
        self.tintColor = SRColors.whiteColor
    }
}

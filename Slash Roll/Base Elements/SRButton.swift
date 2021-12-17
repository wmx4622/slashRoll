//
//  SRButton.swift
//  Slash Roll
//
//  Created by Voxar on 15.12.21.
//

import UIKit

class SRButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButtonAppereance()
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureButtonAppereance() {
        self.snp.makeConstraints { make in
            make.height.equalTo(30)
        }

        self.configuration = .filled()
        self.configuration?.baseBackgroundColor = .blue
        self.configuration?.cornerStyle = .capsule
    }
}

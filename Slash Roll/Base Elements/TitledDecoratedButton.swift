//
//  TitledDecoratedButton.swift
//  Slash Roll
//
//  Created by Voxar on 27.02.22.
//

import UIKit


class TitledDecoratedButton: UIButton {

    //MARK: - Initialization

    required init(title: String, image: UIImage?, frame: CGRect) {
        super.init(frame: frame)
        configureButtonAppearance(title: title, image: image)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Appearance configuration

    private func configureButtonAppearance(title: String, image: UIImage?) {
        setTitle(title, for: .normal)
        setImage(image, for: .normal)
        setTitleColor(SRColors.cherryLightColor, for: .normal)
        tintColor = SRColors.cherryLightColor
        contentVerticalAlignment = .fill
        contentHorizontalAlignment = .fill
    }
}

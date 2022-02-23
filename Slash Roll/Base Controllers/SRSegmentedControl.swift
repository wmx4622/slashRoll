//
//  SRSegmentedControl.swift
//  Slash Roll
//
//  Created by Voxar on 20.02.22.
//

import UIKit


class SRSegmentedControl: UISegmentedControl {

    //MARK: - Properties

    let normalSegmentedControlTitleAttribute: [NSAttributedString.Key: Any] = [.foregroundColor: SRColors.whiteColor]

    let selectedSegmentedControlTitleAttribute: [NSAttributedString.Key: Any] = [.foregroundColor: SRColors.cherryColor]

    //MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureSegmentedControlApperance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Appearance Configuration

    private func configureSegmentedControlApperance() {
            self.selectedSegmentIndex = 0
            self.tintColor = .clear
        self.backgroundColor = SRColors.cherryLightColor
            self.setTitleTextAttributes(normalSegmentedControlTitleAttribute, for: .normal)
            self.setTitleTextAttributes(selectedSegmentedControlTitleAttribute, for: .selected)
            self.removeStyle()

    }

    func removeStyle() {
        setBackgroundImage(UIImage.getImage(from: backgroundColor ?? .clear, imageSize: .init(width: 1, height: 30)), for: .normal, barMetrics: .default)
        setBackgroundImage(UIImage.getImage(from: tintColor, imageSize: .init(width: 1, height: 30)), for: .selected, barMetrics: .default)
        setDividerImage(UIImage.getImage(from: SRColors.whiteColor, imageSize: .init(width: 1, height: 30)), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
}

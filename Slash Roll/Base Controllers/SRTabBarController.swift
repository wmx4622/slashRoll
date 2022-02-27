//
//  SRTabBarController.swift
//  Slash Roll
//
//  Created by Voxar on 17.02.22.
//

import UIKit

class SRTabBarController: UITabBarController {
    
    //MARK: - Tab bar Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarAppearance()
    }

    //MARK: - Tab bar appearance configuration

    private func configureTabBarAppearance() {
        tabBar.tintColor = SRColors.cherryColor
        tabBar.barTintColor = SRColors.whiteColor
        tabBar.isTranslucent = false
        UITabBarItem.appearance().badgeColor = SRColors.cherryLightColor
        view.backgroundColor = SRColors.whiteColor
    }
}

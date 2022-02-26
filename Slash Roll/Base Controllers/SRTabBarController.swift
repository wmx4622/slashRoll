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
        configureTabBarTabs()
        configureTabBarAppearance()

    }

    //MARK: - Tab bar setup

    private func configureTabBarTabs() {
        let catalogController = CatalogViewController()
        catalogController.tabBarItem = UITabBarItem(title: "Католог", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))

        let cartController = CartViewController()
        cartController.tabBarItem = UITabBarItem(title: "Корзина", image: UIImage(systemName: "cart"), selectedImage: UIImage(systemName: "cart.fill"))

        let mapController = MapViewController()
        mapController.tabBarItem = UITabBarItem(title: "Карта", image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill"))

        setViewControllers(
            [
                UINavigationController(rootViewController: catalogController),
                UINavigationController(rootViewController: cartController),
                UINavigationController(rootViewController: mapController)
            ],
            animated: true
        )
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

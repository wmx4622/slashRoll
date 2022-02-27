//
//  SceneDelegate.swift
//  Slash Roll
//
//  Created by Voxar on 14.12.21.
//

import UIKit
import FirebaseAuth


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    let tabBarController = SRTabBarController()

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: scene)

        configureTabBarTabs()

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }

    func configureTabBarTabs() {
        let catalogController = CatalogViewController()
        catalogController.tabBarItem = UITabBarItem(title: "Католог", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))

        let cartController = CartViewController()
        cartController.tabBarItem = UITabBarItem(title: "Корзина", image: UIImage(systemName: "cart"), selectedImage: UIImage(systemName: "cart.fill"))

        let mapController = MapViewController()
        mapController.tabBarItem = UITabBarItem(title: "Карта", image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill"))

        let profileController = ProfileViewController()
        profileController.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))

        let authorizationController = AuthorizationViewController()
        authorizationController.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))

        if Auth.auth().currentUser != nil {

            tabBarController.setViewControllers(
                [
                    UINavigationController(rootViewController: catalogController),
                    UINavigationController(rootViewController: cartController),
                    UINavigationController(rootViewController: mapController),
                    UINavigationController(rootViewController: profileController)
                ],
                animated: true
            )
        } else {
            tabBarController.setViewControllers(
                [
                    UINavigationController(rootViewController: catalogController),
                    UINavigationController(rootViewController: cartController),
                    UINavigationController(rootViewController: mapController),
                    UINavigationController(rootViewController: authorizationController)
                ],
                animated: true
            )
        }
    }

}


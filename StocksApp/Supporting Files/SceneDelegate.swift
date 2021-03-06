//
//  SceneDelegate.swift
//  StocksApp
//
//  Created by Roman Khodukin on 3/28/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = createNavigationController()
        self.window = window
        window.makeKeyAndVisible()
    }

    private func createNavigationController() -> UINavigationController {
        let stockListVC = StocksListViewController()
        stockListVC.title = "Stocks"

        return UINavigationController(rootViewController: stockListVC)
    }
}


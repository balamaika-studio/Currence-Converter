//
//  SceneDelegate.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/16/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let tabBarViewController = UITabBarController()
        
        let converterViewController = R.storyboard.converter.instantiateInitialViewController()!
        converterViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        
        // Favorite
        let favoriteViewController = FavoriteViewController(nib: R.nib.favoriteViewController)
        
        let navigationController = UINavigationController(rootViewController: favoriteViewController)
        navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        
        // Exchanges
        let exchangeRatesViewController = ExchangeRatesViewController(nib: R.nib.exchangeRatesViewController)
        
        let navigationController2 = UINavigationController(rootViewController: exchangeRatesViewController)
        navigationController2.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 2)
        
        
        // Graph
        let graphViewController = GraphViewController(nib: R.nib.graphViewController)
        
        let navigationController3 = UINavigationController(rootViewController: graphViewController)
        navigationController3.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 3)
        
        
        // Settings
        let settingsViewController = SettingsViewController(nib: R.nib.settingsViewController)
        
        let navigationController4 = UINavigationController(rootViewController: settingsViewController)
        navigationController4.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 4)
        
        tabBarViewController.viewControllers = [converterViewController,
                                                navigationController,
                                                navigationController2,
                                                navigationController3,
                                                navigationController4]
        
        window?.rootViewController = tabBarViewController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


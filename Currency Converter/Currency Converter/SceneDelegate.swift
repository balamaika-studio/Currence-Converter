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
    var storage: StorageContext!
    var networkManager: NetworkManager!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        storage = try! RealmStorageContext()
        networkManager = NetworkManager()
        
        let tabBarViewController = AppTabBarController()
        
        let converterViewController = R.storyboard.converter.instantiateInitialViewController()!
        converterViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        
        // Favorite
        let favoriteViewController = FavoriteViewController(nib: R.nib.favoriteViewController)
        
        let navigationController = AppNavigationController(rootViewController: favoriteViewController)
        navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        
        // Exchanges
        let exchangeRatesViewController = ExchangeRatesViewController(nib: R.nib.exchangeRatesViewController)
        
        let navigationController2 = AppNavigationController(rootViewController: exchangeRatesViewController)
        navigationController2.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 2)
        
        
        // Graph
        let graphViewController = GraphViewController(nib: R.nib.graphViewController)
        
        let navigationController3 = AppNavigationController(rootViewController: graphViewController)
        navigationController3.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 3)
        
        
        // Settings
        let settingsViewController = SettingsViewController(nib: R.nib.settingsViewController)
        
        let navigationController4 = AppNavigationController(rootViewController: settingsViewController)
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
        if UserDefaults.standard.bool(forKey: "autoUpdate") {
            print("Load Quotes")
            networkManager.getQuotes { response, errorMessage in
                guard let quotes = response?.quotes else { return }
                UserDefaults.standard.set(response!.updated, forKey: "updated")
                self.updateQuotes(quotes, in: self.storage)
            }
        }
    }
    
    private func updateQuotes(_ quotes: [Quote], in realm: StorageContext) {
        realm.fetch(RealmCurrency.self, predicate: nil, sorted: nil) {
            for currency in $0 {
                let quote = quotes.first { $0.currency == currency.currency }
                guard let newQuote = quote else { return }
                try? realm.update {
                    currency.rate = newQuote.rate
                }
            }
        }
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


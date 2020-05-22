//
//  AppDelegate.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/16/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabBarViewController: UITabBarController!
    var storage: StorageContext!
    var networkManager: NetworkManager!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        storage = try! RealmStorageContext()
        networkManager = NetworkManager()
        restoreAccuracySettings()
        
        tabBarViewController = R.storyboard.main.instantiateInitialViewController()!
        
        let converterViewController = AppViewController.converter.viewController
        let favoriteViewController = AppViewController.favorite.viewController
        let exchangeRatesViewController = AppViewController.exchangeRates.viewController
        let graphViewController = AppViewController.graph.viewController
        let settingsViewController = AppViewController.settings.viewController
        
        tabBarViewController.viewControllers = [converterViewController,
                                                favoriteViewController,
                                                exchangeRatesViewController,
                                                graphViewController,
                                                settingsViewController]
        
        window?.rootViewController = tabBarViewController
        window?.makeKeyAndVisible()
        checkInternetConnection()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if UserDefaults.standard.bool(forKey: "autoUpdate") {
            print("Load Quotes")
            networkManager.getQuotes { response, errorMessage in
                guard let quotes = response?.quotes else { return }
                UserDefaults.standard.set(response!.updated, forKey: "updated")
                self.updateQuotes(quotes, in: self.storage)
            }
        }
    }
    
    //MARK: - Private Methods
    private func checkInternetConnection() {
        ConnectionManager.shared.reachability.whenUnreachable = { _ in
            self.storage.fetch(RealmCurrency.self, predicate: nil, sorted: nil) { [weak self] in
                guard let self = self else { return }
                if $0.isEmpty {
                    // configure modal offline screen
                    self.tabBarViewController.tabBar.isUserInteractionEnabled = false
                    let selectedVC = self.tabBarViewController.selectedViewController
                    let offlineVC = OfflineViewController(nib: R.nib.offlineViewController)
                    let offlineNavigationVC = AppNavigationController(rootViewController: offlineVC)
                    offlineNavigationVC.navigationBar.topItem?.title = R.string.localizable.converterTitle()
                    offlineNavigationVC.modalPresentationStyle = .overCurrentContext
                    
                    // offline screen completion
                    offlineVC.didConnect = { [weak self] in
                        selectedVC?.viewWillAppear(true)
                        self?.tabBarViewController.tabBar.isUserInteractionEnabled = true
                    }
                    // show offline screen
                    selectedVC?.present(offlineNavigationVC, animated: true, completion: nil)
                }
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
    
    private func restoreAccuracySettings() {
        guard let _ = UserDefaults.standard.value(forKey: "accuracy") else {
            AccuracyManager.shared.accurancy = Accuracy.defaultAccurancy.rawValue
            return
        }
    }
}


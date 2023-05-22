//
//  AppDelegate.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/16/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AppsFlyerLib
import AppTrackingTransparency
import AdSupport
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let adUnitID = "ca-app-pub-5773099160082927/4750121114"
    
    var window: UIWindow?
    var tabBarViewController: UITabBarController!
    var storage: StorageContext!
    var networkManager: NetworkManager!
    private var bannerView: GADBannerView!
    private var timer: Timer?
    private var isFirstLaunch: Bool = true
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        storage = try! RealmStorageContext()
        networkManager = NetworkManager()
        restoreAccuracySettings()
        
        tabBarViewController = R.storyboard.main.instantiateInitialViewController()!
        
        let converterViewController = AppViewController.converter.viewController
//        let exchangeRatesViewController = AppViewController.currencyRates.viewController
        let graphViewController = AppViewController.graph.viewController
        let settingsViewController = AppViewController.settings.viewController
        
        tabBarViewController.viewControllers = [converterViewController,
//                                                exchangeRatesViewController,
                                                graphViewController,
                                                settingsViewController]
        if UserDefaultsService.shared.isFirstLoad {
            window?.rootViewController = SplashViewController(nib: R.nib.splashViewController)
        } else {
            window?.rootViewController = tabBarViewController
        }
        window?.makeKeyAndVisible()
        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseNotification(_:)),
                                               name: .IAPHelperPurchaseNotification,
                                               object: nil)
        
        ConverterProducts.store.requestProducts { helper, success, products in
            if success == true, let products = products {
                helper.update(products: products)
            }
        }
        UserDefaultsService.shared.lastUpdateTimeInteraval = Date().timeIntervalSince1970
        checkInternetConnection()
        configureAppsFlyer()
        requestIDFA()
        return true
    }
    
    public func setTabbar() {
        window?.rootViewController = tabBarViewController
        window?.makeKeyAndVisible()
    }
    
    private func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { [weak self] _ in
                DispatchQueue.main.async {
                    self?.setupAds()
                }
            }
        } else {
            setupAds()
        }
    }
    
    private func setupAds() {
        let adsProductId = ConverterProducts.SwiftShopping
        if ConverterProducts.store.isProductPurchased(adsProductId) { return }
        let height = tabBarViewController.tabBar.frame.size.height / 2
        UserDefaults.standard.set(height, forKey: "bannerInset")
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        addBanner(bannerView)
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = tabBarViewController
        bannerView.load(GADRequest())
    }

    private func setupInterstitialAd() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: false) { _ in
            let vc = FullScreenAdController()
            vc.onDismissed = { [weak self] in
                self?.timer?.invalidate()
                self?.timer = nil
                self?.setupInterstitialAd()
            }
            vc.loadInterstitialAd(id: "ca-app-pub-5773099160082927/1278122807") { [weak self, weak vc] in
                guard $0, let self = self, let vc = vc else { return }
                self.window?.rootViewController?.present(vc, animated: true)
            }
        }
    }
    
    private func configureAppsFlyer() {
        let appsFlyer = AppsFlyerLib.shared()
        appsFlyer.appsFlyerDevKey = "6sG9tvthbLbQdohMzWSCy4"
        appsFlyer.appleAppID = "1512175521"
        appsFlyer.delegate = self
        if #available(iOS 14, *) {
            appsFlyer.waitForATTUserAuthorization(timeoutInterval: 30)
        }
        #if DEBUG
        appsFlyer.isDebug = true
        #endif
    }
    
    func addBanner(_ bannerView: GADBannerView) {
        let height = GADAdSizeBanner.size.height
        tabBarViewController.additionalSafeAreaInsets.bottom += height
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        tabBarViewController.view.addSubview(bannerView)
        bannerView.bottomAnchor.constraint(equalTo: tabBarViewController.view.bottomAnchor).isActive = true
        bannerView.heightAnchor.constraint(equalToConstant: height).isActive = true
        bannerView.leadingAnchor.constraint(equalTo: tabBarViewController.view.leadingAnchor).isActive = true
        bannerView.trailingAnchor.constraint(equalTo: tabBarViewController.view.trailingAnchor).isActive = true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if UserDefaults.standard.bool(forKey: "autoUpdate") {
            print("Load Quotes")
            networkManager.getQuotes(exchangeType: .forex) { response, errorMessage in
                guard let quotes = response?.quotes else { return }
                UserDefaults.standard.set(response!.updated, forKey: "updated")
                self.updateQuotes(quotes, in: self.storage)
            }

            networkManager.getQuotes(exchangeType: .crypto) { response, errorMessage in
                guard let quotes = response?.quotes else { return }
                UserDefaults.standard.set(response!.updated, forKey: "updated")
                self.updateQuotes(quotes, in: self.storage)
            }
        }
        
        AppsFlyerLib.shared().start()
        let adsProductId = ConverterProducts.SwiftShopping
        if ConverterProducts.store.isProductPurchased(adsProductId) { return }
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { [weak self] _ in
                DispatchQueue.main.async {
                    self?.setupInterstitialAd()
                }
            }
        } else {
            setupInterstitialAd()
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        AppsFlyerLib.shared().handleOpen(url, options: options)
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            AppsFlyerLib.shared().handlePushNotification(userInfo)
            completionHandler(.noData)
        }

    func applicationDidEnterBackground(_ application: UIApplication) {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        guard let productID = notification.object as? String else { return }
        DispatchQueue.main.async {
            if ConverterProducts.SwiftShopping == productID, let bannerView = self.bannerView {
                bannerView.removeFromSuperview()
                let height = self.tabBarViewController.tabBar.frame.size.height / 2
                UserDefaults.standard.set(height, forKey: "bannerInset")
            }
        }
    }
    
    //MARK: - Private Methods
    private func checkInternetConnection() {
        ConnectionManager.shared.reachability.whenUnreachable = { _ in
            self.storage.fetch(RealmCurrencyV2.self, predicate: nil, sorted: nil) { [weak self] in
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
                        ConnectionManager.stopNotifier()
                    }
                    // show offline screen
                    selectedVC?.present(offlineNavigationVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    private func updateQuotes(_ quotes: [Quote], in realm: StorageContext) {
        realm.fetch(RealmCurrencyV2.self, predicate: nil, sorted: nil) {
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
            AccuracyManager.shared.accuracy = Accuracy.defaultAccurancy.rawValue
            return
        }
    }
}

extension AppDelegate: AppsFlyerLibDelegate {
    func onConversionDataFail(_ error: Error) {
        
    }
    
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        
    }
}

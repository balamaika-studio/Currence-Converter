//
//  AppDelegate.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/16/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit
import AppTrackingTransparency
import AdSupport
import Appodeal
import StackConsentManager
import Firebase

let kIsTablet = (UIDevice.current.userInterfaceIdiom == .pad)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, STKConsentManagerDisplayDelegate {
    
    private let adUnitID = "ca-app-pub-5773099160082927/4750121114"
    
    var window: UIWindow?
    var tabBarViewController: AppTabBarController!
    var storage: StorageContext!
    var networkManager: NetworkManager!
    private var bannerView: APDBannerView!
    private var timer: Timer?
    private var isFirstLaunch: Bool = true
    private struct AppodealConstants {
        static let key: String = "3481d44187da8f04f1bd4a97ceab68b99c79f2e77f9c5bd2"
        static let adTypes: AppodealAdType = [.interstitial, .rewardedVideo, .banner]
        static let logLevel: APDLogLevel = .debug
        static let interPlacement = "Inter"
#if DEBUG
        static let testMode: Bool = true
#else
        static let testMode: Bool = false
#endif
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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
            UserDefaultsService.shared.purchaseViewShowCounter += 1
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
        FirebaseApp.configure()
        
        STKConsentManager.shared().synchronize(withAppKey: AppodealConstants.key) { [weak self] error in
            error.map { print("Error while synchronising consent manager: \($0)") }
            guard STKConsentManager.shared().shouldShowConsentDialog == .true else {
                self?.initializeAppodealSDK()
                return
            }
    
            // Load and present consent dialog
            STKConsentManager.shared().loadConsentDialog { [weak self] error in
                error.map { print("Error while loading consent dialog: \($0)") }
                guard
                    let controller = self?.window?.rootViewController,
                    STKConsentManager.shared().isConsentDialogReady
                else {
                    self?.initializeAppodealSDK()
                    return
                }
                // Show consent dialog
                STKConsentManager.shared().showConsentDialog(fromRootViewController: controller, delegate: self)
            }
        }

        return true
    }
    
    // MARK: Appodeal Initialization
    private func initializeAppodealSDK() {
        /// Custom settings
        // Appodeal.setFramework(.native, version: "1.0.0")
        // Appodeal.setTriggerPrecacheCallbacks(true)
        // Appodeal.setLocationTracking(true)
        Appodeal.setLogLevel(AppodealConstants.logLevel)
        Appodeal.setAutocache(true, types: AppodealConstants.adTypes)
        
        /// Test Mode
        Appodeal.setTestingEnabled(false)
        
        /// User Data
        // Appodeal.setUserId("userID")
        
        
        // Initialise Appodeal SDK
        Appodeal.setInitializationDelegate(self)
        Appodeal.initialize(withApiKey: AppodealConstants.key, types: AppodealConstants.adTypes)
        Appodeal.cacheAd(.banner)
    }
    
    public func setTabbar() {
        window?.rootViewController = tabBarViewController
        window?.makeKeyAndVisible()
    }
    
    private func requestIDFA() {
        setupAds()
    }
    
    private func setupAds() {
        let adsProductId = ConverterProducts.SwiftShopping
        if ConverterProducts.store.isProductPurchased(adsProductId) { return }
//        let height = tabBarViewController.tabBar.frame.size.height / 2
//        UserDefaults.standard.set(height, forKey: "bannerInset")
//        let bannerSize = kIsTablet ? kAPDAdSize728x90 : kAPDAdSize320x50
//        bannerView = AppodealBannerView(size: bannerSize, rootViewController: tabBarViewController)
//        bannerView.delegate = tabBarViewController
//        bannerView.placement = "Banner"
//        bannerView.loadAd()
//        addBanner(bannerView)
        Appodeal.canShow(.banner, forPlacement: "Banner")
    }

    private func setupInterstitialAd() {
        let adsProductId = ConverterProducts.SwiftShopping
        if ConverterProducts.store.isProductPurchased(adsProductId) { return }
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: false) { [weak self] _ in
            self?.tabBarViewController.onDismissed = { [weak self] in
                self?.timer?.invalidate()
                self?.timer = nil
                self?.setupInterstitialAd()
            }

            Appodeal.setInterstitialDelegate(self?.tabBarViewController)
            guard Appodeal.isInitialized(for: .interstitial),
                  Appodeal.isReadyForShow(with: .interstitial)
            else {
                return
            }
            
            Appodeal.showAd(
                .interstitial,
                forPlacement: AppodealConstants.interPlacement,
                rootViewController: self?.tabBarViewController
            )
        }
    }
    
    func addBanner(_ bannerView: AppodealBannerView) {
        let bannerSize = kIsTablet ? kAPDAdSize728x90 : kAPDAdSize320x50
        let height = bannerSize.height
        tabBarViewController.additionalSafeAreaInsets.bottom += height
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        tabBarViewController.view.addSubview(bannerView)
        bannerView.bottomAnchor.constraint(equalTo: tabBarViewController.view.bottomAnchor).isActive = true
        bannerView.heightAnchor.constraint(equalToConstant: height).isActive = true
        bannerView.leadingAnchor.constraint(equalTo: tabBarViewController.view.leadingAnchor).isActive = true
        bannerView.trailingAnchor.constraint(equalTo: tabBarViewController.view.trailingAnchor).isActive = true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        var canUpdate = false
        let adsProductId = ConverterProducts.SwiftShopping
        
        if !ConverterProducts.store.isProductPurchased(adsProductId) &&
            (Date().timeIntervalSince1970 - UserDefaultsService.shared.lastUpdateTimeInteraval) < 3600 {
            canUpdate = false
        } else if !ConverterProducts.store.isProductPurchased(adsProductId) &&
                    (Date().timeIntervalSince1970 - UserDefaultsService.shared.lastUpdateTimeInteraval) > 3600 {
            canUpdate = true
        } else if ConverterProducts.store.isProductPurchased(adsProductId) && UserDefaults.standard.bool(forKey: "autoUpdate") {
            canUpdate = true
        } else {
            canUpdate = false
        }
        
        if canUpdate {
            networkManager.getQuotes(exchangeType: .forex) { response, errorMessage in
                guard let quotes = response?.quotes else { return }
                UserDefaults.standard.set(response!.updated, forKey: "updated")
                UserDefaultsService.shared.lastUpdateTimeInteraval = Date().timeIntervalSince1970
                self.updateQuotes(quotes, in: self.storage)
            }
            
            networkManager.getQuotes(exchangeType: .crypto) { response, errorMessage in
                guard let quotes = response?.quotes else { return }
                UserDefaults.standard.set(response!.updated, forKey: "updated")
                let currenciesInfo = CurrenciesInfoService.shared.fetchCrypto()
                let filteredQuotes = quotes.filter { quote in
                    currenciesInfo.contains { info in
                        quote.currency == info.abbreviation
                    }
                }
                UserDefaultsService.shared.lastUpdateTimeInteraval = Date().timeIntervalSince1970
                self.updateQuotes(filteredQuotes, in: self.storage)
            }
        }
        
        if ConverterProducts.store.isProductPurchased(adsProductId) { return }
        setupInterstitialAd()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
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
            if ConverterProducts.SwiftShopping == productID {
                Appodeal.hideBanner()
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
    
    func consentManagerWillShowDialog(_ consentManager: STKConsentManager) {
        initializeAppodealSDK()
    }
    
    func consentManager(_ consentManager: STKConsentManager, didFailToPresent error: Error) {
        initializeAppodealSDK()
    }
    
    func consentManagerDidDismissDialog(_ consentManager: STKConsentManager) {
        let report = STKConsentManager.shared().consent!
        Appodeal.updateConsentReport(report)
        initializeAppodealSDK()
    }
}

extension AppDelegate: AppodealInitializationDelegate {
    func appodealSDKDidInitialize() {
        requestIDFA()
    }
}

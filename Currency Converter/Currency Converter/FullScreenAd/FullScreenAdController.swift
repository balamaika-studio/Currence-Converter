//
//  FullScreenAdController.swift
//  Currency Converter
//
//  Created by Александр Томашевский on 23.12.2021.
//  Copyright © 2021 Kiryl Klimiankou. All rights reserved.
//

import UIKit
import GoogleMobileAds

final class FullScreenAdController: UIViewController, GADFullScreenContentDelegate {
    
    private var interstitialAd: GADInterstitialAd?
    var onDismissed: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interstitialAd?.present(fromRootViewController: self)
    }
    
    func loadInterstitialAd(id: String, completion: ((Bool)->Void)?) {
        GADInterstitialAd.load(withAdUnitID: id,
                               request: GADRequest()) { [weak self] ad, error in
            ad?.fullScreenContentDelegate = self
            self?.interstitialAd = ad
            completion?(error == nil)
        }
    }
    
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad presented")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        presentingViewController?.dismiss(animated: true)
        onDismissed?()
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        presentingViewController?.dismiss(animated: true)
        onDismissed?()
        print("ad failed with error: \(error)")
    }
}

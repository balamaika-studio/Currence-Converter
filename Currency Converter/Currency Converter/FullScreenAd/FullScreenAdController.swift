//
//  FullScreenAdController.swift
//  Currency Converter
//
//  Created by Vlad Sys on 12.10.22.
//  Copyright © 2022 Kiryl Klimiankou. All rights reserved.
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
        if interstitialAd != nil {
            interstitialAd?.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }

    func loadInterstitialAd(id: String, completion: ((Bool)->Void)?) {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: id,
                               request: request) { [self] ad, error in
            interstitialAd = ad
            interstitialAd?.fullScreenContentDelegate = self
            completion?(error == nil)
        }
    }

    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
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

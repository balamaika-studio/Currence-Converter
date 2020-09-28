//
//  ConverterProducts.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 9/4/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation
import AppsFlyerLib

public protocol EventTracker {
    func trackPurchase(id: String, productIdentifier: String, revenue: Float)
}

public struct ConverterProducts {
    
    public static let SwiftShopping = "Maksim.Haroshka.CurrencyConverter.NoAds"
    
    private static let productIdentifiers: Set<ProductIdentifier> = [ConverterProducts.SwiftShopping]
    
    public static let store = IAPHelper(productIds: ConverterProducts.productIdentifiers, eventTracker: AppsFlyerEventTracker())
    
    fileprivate static let subscriptionsProductIdentifiers: Set<ProductIdentifier> = []
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}

struct AppsFlyerEventTracker: EventTracker {
    func trackPurchase(id: String, productIdentifier: String, revenue: Float) {
        // AppsFlyer
        let event = ConverterProducts.subscriptionsProductIdentifiers.contains(productIdentifier) ? AFEventSubscribe : AFEventPurchase

        print("ID: \(id)")
        print("PROD: \(productIdentifier)")

        let receiptString: String

        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
            FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {

            do {
                let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                receiptString = receiptData.base64EncodedString(options: [])
            }
            catch {
                receiptString = ""
            }
        } else {
            receiptString = ""
        }

        AppsFlyerTracker.shared().trackEvent(event,
                                         withValues: [
                                            AFEventParamOrderId: id,
                                            AFEventParamContentId: productIdentifier,
                                            AFEventParamRevenue: revenue,
                                            AFEventParamCurrency:"USD",
                                            "af_purchase_token": receiptString
        ]);
    }
}

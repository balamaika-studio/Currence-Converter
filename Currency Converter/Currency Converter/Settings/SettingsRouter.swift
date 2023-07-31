//
//  SettingsRouter.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/20/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol SettingsRoutingLogic {
    func showPurchaseViewController()
}

class SettingsRouter: NSObject, SettingsRoutingLogic {
    
    weak var viewController: SettingsViewController?
    
    // MARK: Routing
    
    func showPurchaseViewController() {
        guard let viewController = viewController else {
            fatalError("Fail route to second")
        }
        let purchaseVc = PurchaseViewController(nib: R.nib.purchaseViewController)
        viewController.present(purchaseVc, animated: true)
    }
    
}

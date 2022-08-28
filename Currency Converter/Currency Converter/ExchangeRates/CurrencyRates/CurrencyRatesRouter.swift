//
//  CurrencyRatesRouter.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/9/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol CurrencyRatesRoutingLogic {
    func showExchangeRatesViewController()
}

class CurrencyRatesRouter: NSObject, CurrencyRatesRoutingLogic {
    
    weak var viewController: CurrencyRatesViewController?
    
    // MARK: Routing

    func showExchangeRatesViewController() {
        guard let viewController = viewController else {
                fatalError("Fail route to second")
        }
        let favoriteViewController = ExchangeRatesViewController(nib: R.nib.exchangeRatesViewController)
        favoriteViewController.modalPresentationStyle = .overFullScreen
        favoriteViewController.delegate = viewController
        viewController.present(favoriteViewController, animated: true, completion: nil)
    }
}

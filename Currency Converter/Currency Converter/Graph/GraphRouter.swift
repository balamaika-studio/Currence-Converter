//
//  GraphRouter.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/17/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol GraphRoutingLogic {
    func showChoiceViewController(isLeft: Bool, oppositeCurrency: String)
    func showPurchaseViewController()
}

class GraphRouter: ChoiceDataPassing {
    weak var viewController: GraphViewController?
    var dataStore: ChoiceDataStore?
    
    // MARK: Routing
    func showChoiceViewController(isLeft: Bool, oppositeCurrency: String) {
        guard
            let viewController = viewController
            else { fatalError("Graph fail route") }
        
        let choiceVc = ChoiceViewController(nib: R.nib.choiceViewController)
        choiceVc.isShowGraphCurrencies = true
        choiceVc.isCrypto = false
        choiceVc.isLeft = isLeft
        choiceVc.oppositeCurrency = oppositeCurrency
//        choiceVc.modalPresentationStyle = .overFullScreen
        viewController.present(choiceVc, animated: true, completion: nil)
    }
    
    func showPurchaseViewController() {
        guard let viewController = viewController else {
            fatalError("Fail route to second")
        }
        let purchaseVc = PurchaseViewController(nib: R.nib.purchaseViewController)
        viewController.present(purchaseVc, animated: true)
    }
}

extension GraphRouter: GraphRoutingLogic {
    private func present(source: UIViewController, destination: UIViewController) {
        destination.modalPresentationStyle = .custom
        source.present(destination, animated: true, completion: nil)
    }
}

//
//  GraphCryptoRouter.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/17/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol GraphCryptoRoutingLogic {
    func showChoiceViewController()
}

class GraphCryptoRouter: ChoiceDataPassing {
    weak var viewController: GraphCryptoViewController?
    var dataStore: ChoiceDataStore?
    
    // MARK: Routing
    func showChoiceViewController() {
        guard
            let viewController = viewController
            else { fatalError("GraphCrypto fail route") }
        
        let choiceVc = ChoiceViewController(nib: R.nib.choiceViewController)
        choiceVc.isShowGraphCurrencies = true
        choiceVc.isCrypto = true
        choiceVc.modalPresentationStyle = .overFullScreen
        viewController.present(choiceVc, animated: true, completion: nil)
    }
}

extension GraphCryptoRouter: GraphCryptoRoutingLogic {
    private func present(source: UIViewController, destination: UIViewController) {
        destination.modalPresentationStyle = .custom
        source.present(destination, animated: true, completion: nil)
    }
}

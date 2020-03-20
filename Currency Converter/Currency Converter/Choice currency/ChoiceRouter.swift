//
//  ChoiceRouter.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/17/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol ChoiceRoutingLogic {
    func closeChoiceViewController()
}

protocol ChoiceDataPassing {
    var dataStore: ChoiceDataStore? { get }
}

class ChoiceRouter {
    weak var viewController: ChoiceViewController?
    var dataStore: ChoiceDataStore?
    
    // MARK: Routing
    
    func closeChoiceViewController() {
        let converterViewController = ((viewController?.presentingViewController as? UITabBarController)?
            .selectedViewController as? UINavigationController)?
            .topViewController as? ConverterViewController

        guard
            let choiceVC = viewController,
            let choiceDataStore = dataStore,
            let converterVC = converterViewController,
            var converterDataStore = converterVC.router?.dataStore
        else { fatalError("Fail route to back") }
        passDataBack(source: choiceDataStore, destination: &converterDataStore)
//        converterVC.interactor?.makeRequest(request: .changeCurrency)
        close(choiceVC)
    }
}

// MARK: - Navigation
extension ChoiceRouter: ChoiceRoutingLogic {
    private func close(_ vc: UIViewController) {
        vc.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Data Passing
extension ChoiceRouter: ChoiceDataPassing {
    private func passDataBack(source: ChoiceDataStore, destination: inout ConverterDataStore) {
        destination.selectedCurrency = source.selectedCurrency
    }
}

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
    func dismissViewController()
}

protocol ChoiceDataPassing {
    var dataStore: ChoiceDataStore? { get }
}

protocol ChoiceBackDataPassing {
    func getRouter() -> ChoiceDataPassing
    func updateControllerWithSelectedCurrency()
}

class ChoiceRouter {
    weak var viewController: ChoiceViewController?
    var dataStore: ChoiceDataStore?
    
    // MARK: Routing
    
    func closeChoiceViewController() {
        let destinationViewController = ((viewController?.presentingViewController as? UITabBarController)?
            .selectedViewController as? UINavigationController)?
            .topViewController as? ChoiceBackDataPassing
//        var destinationViewController: ChoiceBackDataPassing?
//         ((viewController?.presentingViewController as? UITabBarController)?
//            .selectedViewController as? UINavigationController)?
//            .topViewController?.children.forEach({ vc in
//                if vc is ChoiceBackDataPassing {
//                    destinationViewController = vc as? ChoiceBackDataPassing
//                }
//            })

        guard
            let choiceVC = viewController,
            let choiceDataStore = dataStore,
            let destinationVC = destinationViewController,
            var converterDataStore = destinationVC.getRouter().dataStore
        else { fatalError("Fail route to back") }
        passDataBack(source: choiceDataStore, destination: &converterDataStore)
        destinationVC.updateControllerWithSelectedCurrency()
        close(choiceVC)
    }

    func dismissViewController() {
        guard let viewController = viewController else {
            return
        }

        close(viewController)
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
    private func passDataBack(source: ChoiceDataStore, destination: inout ChoiceDataStore) {
        destination.selectedCurrency = source.selectedCurrency
    }
}

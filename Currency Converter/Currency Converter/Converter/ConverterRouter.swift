//
//  ConverterRouter.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/16/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol ConverterRoutingLogic {
    func showChoiceViewController()
}

protocol ConverterDataPassing {
    var dataStore: ConverterDataStore? { get }
}

class ConverterRouter {
    weak var viewController: ConverterViewController?
    var dataStore: ConverterDataStore?
    
    // MARK: Routing
    
    func showChoiceViewController() {
        guard
            let viewController = viewController
//            let firstDataStore = dataStore,
//            var secondDataStore = secondVc.router?.dataStore
            else { fatalError("Fail route to second") }
        
        let secondVc = ChoiceViewController(nib: R.nib.choiceViewController)
        
//        passDataToSecond(source: firstDataStore, destination: &secondDataStore)
        present(source: viewController, destination: secondVc)
    }
}

// MARK: - Navigation
extension ConverterRouter: ConverterRoutingLogic {
    private func present(source: UIViewController, destination: UIViewController) {
        
        destination.modalPresentationStyle = .custom
        destination.transitioningDelegate = source as? ConverterViewController
        destination.view.backgroundColor = .red
        
        source.present(destination, animated: true, completion: nil)
//        source.navigationController?.pushViewController(destination, animated: true)
    }
}

// MARK: - Passing Data
extension ConverterRouter: ConverterDataPassing {
//    private func passDataToSecond(source: FirstDataStore, destination: inout SecondDataStore) {
//        destination.number = source.number
//    }
}


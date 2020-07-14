//
//  GraphRouter.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/17/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol GraphRoutingLogic {
    func showChoiceViewController()
}

class GraphRouter: ChoiceDataPassing {
    weak var viewController: GraphViewController?
    var dataStore: ChoiceDataStore?
    
    // MARK: Routing
    func showChoiceViewController() {
        guard
            let viewController = viewController
            else { fatalError("Graph fail route") }
        
        let choiceVc = ChoiceViewController(nib: R.nib.choiceViewController)
        choiceVc.isShowGraphCurrencies = true
        present(source: viewController, destination: choiceVc)
    }
}

extension GraphRouter: GraphRoutingLogic {
    private func present(source: UIViewController, destination: UIViewController) {
        destination.modalPresentationStyle = .custom
        destination.transitioningDelegate = source as? GraphViewController
        source.present(destination, animated: true, completion: nil)
    }
}

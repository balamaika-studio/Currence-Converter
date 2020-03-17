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

class ChoiceRouter {
  weak var viewController: ChoiceViewController?
  
  // MARK: Routing
  
    func closeChoiceViewController() {
        guard let choiceVC = viewController else { return }
        close(choiceVC)
    }
}

// MARK: - Navigation
extension ChoiceRouter: ChoiceRoutingLogic {
    private func close(_ vc: UIViewController) {
        vc.dismiss(animated: true, completion: nil)
    }
}

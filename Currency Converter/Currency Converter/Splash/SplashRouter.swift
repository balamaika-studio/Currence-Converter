//
//  FavoriteRouter.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/26/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol SplashRoutingLogic {
    func dismiss()
}

class SplashRouter: NSObject, SplashRoutingLogic {
    
    weak var viewController: SplashViewController?
    
    // MARK: Routing
    func dismiss() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.setTabbar()
        }
    }
}

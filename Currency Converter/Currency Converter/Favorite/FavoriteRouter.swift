//
//  FavoriteRouter.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/26/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol FavoriteRoutingLogic {
    func dismiss()
}

class FavoriteRouter: NSObject, FavoriteRoutingLogic {
    
    weak var viewController: FavoriteViewController?
    
    // MARK: Routing
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}

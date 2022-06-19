//
//  FavoriteRouter.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/26/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol FavoriteCurrencyRoutingLogic {
    func dismiss()
}

class FavoriteCurrencyRouter: NSObject, FavoriteCurrencyRoutingLogic {
    
    weak var viewController: FavoriteCurrencyViewController?
    
    // MARK: Routing
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}

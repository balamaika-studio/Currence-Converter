//
//  FavoriteCryptocurrencyPresenter.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/26/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol PurchasePresentationLogic {
    func presentData(response: Purchase.Model.Response.ResponseType)
}

class PurchasePresenter: PurchasePresentationLogic {
    weak var viewController: PurchaseDisplayLogic?
    
    func presentData(response: Purchase.Model.Response.ResponseType) {
        switch response {
        case .products(let products):
            viewController?.displayData(viewModel: .products(products))
        }
    }
}

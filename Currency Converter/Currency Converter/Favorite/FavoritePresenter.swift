//
//  FavoritePresenter.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/26/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol FavoritePresentationLogic {
    func presentData(response: Favorite.Model.Response.ResponseType)
}

class FavoritePresenter: FavoritePresentationLogic {
    weak var viewController: FavoriteDisplayLogic?
    
    func presentData(response: Favorite.Model.Response.ResponseType) {
        switch response {
        case .currencies(let quotes):
            let sortedQuotes = quotes.sorted { $0.currency < $1.currency }
            viewController?.displayData(viewModel: .showCurrencies(sortedQuotes))
        }
    }
    
}

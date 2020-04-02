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
    
    private var quotes: [FavoriteViewModel]!
    
    func presentData(response: Favorite.Model.Response.ResponseType) {
        switch response {
        case .currencies(let currencies, let info):
            var result = [FavoriteViewModel]()
            let validCurrencies = currencies.filter { currency in
                return info.contains { $0.abbreviation == currency.currency }
            }
            
            validCurrencies.forEach { value in
                let currencyTitle = info.first { $0.abbreviation == value.currency }!.title
                let viewModel = FavoriteViewModel(currency: value.currency,
                                                title: currencyTitle,
                                                isSelected: value.isFavorite)
                result.append(viewModel)
            }
            let sortedQuotes = result.sorted { $0.title < $1.title }
            quotes = sortedQuotes
            viewController?.displayData(viewModel: .showCurrencies(sortedQuotes))
            
        case .filter(let title):
            let filteredQuotes = title.isEmpty ? quotes : quotes.filter { quote in
                quote.title.lowercased().contains(title.lowercased())
            }
            viewController?.displayData(viewModel: .showCurrencies(filteredQuotes ?? []))
        }
    }
}

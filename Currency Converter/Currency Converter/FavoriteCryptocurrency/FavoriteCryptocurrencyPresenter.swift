//
//  FavoriteCryptocurrencyPresenter.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/26/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol FavoriteCryptocurrencyPresentationLogic {
    func presentData(response: Favorite.Model.Response.ResponseType)
}

class FavoriteCryptocurrencyPresenter: FavoriteCryptocurrencyPresentationLogic {
    weak var viewController: FavoriteCryptocurrencyDisplayLogic?
    
    private var quotes: [FavoriteViewModel]!
    private var filteredQuotes: [FavoriteViewModel]?
    
    func presentData(response: Favorite.Model.Response.ResponseType) {
        
        // TODO: - Replace to functions
        
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
            
        case .update(let viewModel, let isSelected):
            let index = quotes.firstIndex(of: viewModel)!
            quotes[index].isSelected = isSelected
            
            if let filteredQuotes = filteredQuotes, !filteredQuotes.isEmpty {
                let filterIndex = filteredQuotes.firstIndex(of: viewModel)!
                self.filteredQuotes![filterIndex].isSelected = isSelected
            }
            
            let result = filteredQuotes == nil ? quotes : filteredQuotes
            viewController?.displayData(viewModel: .showCurrencies(result ?? []))
            
        case .filter(let text):
            let filter = text.lowercased()
            let filteredQuotes = text.isEmpty ? quotes : quotes.filter { quote in
                let title = quote.title.lowercased()
                let currency = quote.currency.lowercased()
                return title.contains(filter) || currency.contains(filter)
            }
            self.filteredQuotes = filteredQuotes
            viewController?.displayData(viewModel: .showCurrencies(filteredQuotes ?? []))
        }
    }
}

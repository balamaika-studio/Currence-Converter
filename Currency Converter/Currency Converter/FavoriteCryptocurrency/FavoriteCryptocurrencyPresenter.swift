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
        case .currenciesConverter(let currencies, let info, let currencyPair):
            var result = [FavoriteViewModel]()
            let validCurrencies = currencies.filter { currency in
                return info.contains { $0.abbreviation == currency.currency }
            }
            
            validCurrencies.forEach { value in
                let currencyInfValue = info.first { $0.abbreviation == value.currency }
                let viewModel = FavoriteViewModel(currency: value.currency,
                                                  title: currencyInfValue?.title ?? "",
                                                  isSelected: value.isFavorite,
                                                  isFree: currencyInfValue?.isFree ?? true)
                if currencyInfValue?.isFree ?? true {
                    result.append(viewModel)
                }
            }
            let sortedQuotes = result.sorted { $0.title < $1.title }
            quotes = sortedQuotes
            viewController?.displayData(viewModel: .showCurrencies(sortedQuotes))

        case .currenciesExchange(let currencies, let info, let currencyPair, let mainCurrency):
            var result = [FavoriteViewModel]()
            let validCurrencies = currencies.filter { currency in
                return info.contains { $0.abbreviation == currency.currency }
            }

            validCurrencies.forEach { value in
                let currencyInfValue = info.first { $0.abbreviation == value.currency }
                let viewModel = FavoriteViewModel(currency: value.currency,
                                                  title: currencyInfValue?.title ?? "",
                                                  isSelected: value.isFavorite,
                                                  isFree: currencyInfValue?.isFree ?? true)
                if currencyInfValue?.isFree ?? true {
                    result.append(viewModel)
                }
            }
            let sortedQuotes = result.sorted { $0.title < $1.title }
            let sortQuotes = sortedQuotes.filter { model in
                currencyPair.contains {
                    ($0.base == model.currency && $0.relative == mainCurrency) || ($0.relative == model.currency && $0.base == mainCurrency)
                }
            }
            quotes = sortQuotes
            viewController?.displayData(viewModel: .showCurrencies(sortQuotes))
            
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

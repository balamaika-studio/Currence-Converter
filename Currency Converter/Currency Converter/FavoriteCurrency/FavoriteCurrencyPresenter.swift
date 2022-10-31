//
//  FavoriteCurrencyPresenter.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/26/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol FavoriteCurrencyPresentationLogic {
    func presentData(response: Favorite.Model.Response.ResponseType)
}

class FavoriteCurrencyPresenter: FavoriteCurrencyPresentationLogic {
    weak var viewController: FavoriteCurrencyDisplayLogic?
    
    private var quotes: [FavoriteViewModel]!
    private var filteredQuotes: [FavoriteViewModel]?
    
    func presentData(response: Favorite.Model.Response.ResponseType) {
        
        switch response {
        case .currenciesConverter(let currencies, let info, let currencyPair):
            var result = [FavoriteViewModel]()
            let validCurrencies = currencies.filter { currency in
                return info.contains { $0.abbreviation == currency.currency }
            }

            var currentValidCurrencies: [RealmCurrencyV2] = []
            currentValidCurrencies.appendDistinct(contentsOf: validCurrencies, where: { (cur1, cur2) -> Bool in
                    return cur1.currency != cur2.currency
            })
            
            currentValidCurrencies.forEach { value in
                let currencyTitle = info.first { $0.abbreviation == value.currency }!.title
                let viewModel = FavoriteViewModel(currency: value.currency,
                                                title: currencyTitle,
                                                isSelected: value.isFavorite)
                result.append(viewModel)
            }
            let sortedQuotes = result.sorted { $0.title < $1.title }
            let sortQuotes = sortedQuotes.filter { model in
                currencyPair.contains {
                    $0.base == model.currency || $0.relative == model.currency
                }
            }
            quotes = sortQuotes
            viewController?.displayData(viewModel: .showCurrencies(sortQuotes))

        case .currenciesExchange(let currencies, let info, let currencyPair, let mainCurrency):
            var result = [FavoriteViewModel]()
            let validCurrencies = currencies.filter { currency in
                return info.contains { $0.abbreviation == currency.currency }
            }

            var currentValidCurrencies: [RealmCurrencyV2] = []
            currentValidCurrencies.appendDistinct(contentsOf: validCurrencies, where: { (cur1, cur2) -> Bool in
                    return cur1.currency != cur2.currency
            })

            currentValidCurrencies.forEach { value in
                let currencyTitle = info.first { $0.abbreviation == value.currency }!.title
                let viewModel = FavoriteViewModel(currency: value.currency,
                                                title: currencyTitle,
                                                isSelected: false)
                result.append(viewModel)
            }
            let mainCurrencyModel = result.first {
                $0.currency == mainCurrency
            }

            var sortQuotes = result.filter { model in
                currencyPair.contains {
                    ($0.base == model.currency && $0.relative == mainCurrency) || ($0.relative == model.currency && $0.base == mainCurrency)
                }
            }
            if let mainCurrencyModel = mainCurrencyModel {
                sortQuotes.append(mainCurrencyModel)
            }

            let sortedQuotes = sortQuotes.sorted { $0.title < $1.title }
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

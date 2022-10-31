//
//  ChoicePresenter.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/17/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol ChoicePresentationLogic {
    func presentData(response: Choice.Model.Response.ResponseType)
}

class ChoicePresenter: ChoicePresentationLogic {
    weak var viewController: ChoiceDisplayLogic?
    var currencyViewModels: [ChoiceCurrencyViewModel]!
    var filteredCurrencyViewModels: [ChoiceCurrencyViewModel]?
    
    func presentData(response: Choice.Model.Response.ResponseType) {
        switch response {
        case .currencies(let currencies, let info, let pairCurrency, let oppositeCurrency):
            let viewModels = buildViewModels(currencies, info, pairCurrency, oppositeCurrency)
            currencyViewModels = viewModels
            viewController?.displayData(viewModel: .displayCurrencies(viewModels))
        case .filter(let text):
            let filter = text.lowercased()
            let filteredQuotes = text.isEmpty ? currencyViewModels : currencyViewModels?.filter { quote in
                let title = quote.title.lowercased()
                let currency = quote.currency.lowercased()
                return title.contains(filter) || currency.contains(filter)
            }
            self.filteredCurrencyViewModels = filteredQuotes
            viewController?.displayData(viewModel: .displayCurrencies(filteredQuotes ?? []))
        }
    }
        
    private func buildViewModels(_ currencies: [Currency], _ info: [CurrencyInfo], _ pairCurrency: [RealmPairCurrencyV2], _ oppositeCurrency: String) -> [ChoiceCurrencyViewModel] {
        var result = [ChoiceCurrencyViewModel]()
        let validCurrencies = currencies.filter { currency in
            return info.contains { $0.abbreviation == currency.currency }
        }

        var currentValidCurrencies: [Currency] = []
        currentValidCurrencies.appendDistinct(contentsOf: validCurrencies, where: { (cur1, cur2) -> Bool in
                return cur1.currency != cur2.currency
        })
        
        currentValidCurrencies.forEach { value in
            let currencyTitle = info.first { $0.abbreviation == value.currency }!.title
            let viewModel = ChoiceCurrencyViewModel(currency: value.currency,
                                                    title: currencyTitle)
            result.append(viewModel)
        }

        let mainCurrencyModel = result.first {
            $0.currency == oppositeCurrency
        }

        var sortedViewModel = result.filter { model in
            pairCurrency.contains {
                ($0.base == model.currency && $0.relative == oppositeCurrency) || ($0.relative == model.currency && $0.base == oppositeCurrency)
            }
        }

        if let mainCurrencyModel = mainCurrencyModel {
            sortedViewModel.append(mainCurrencyModel)
        }

        let sortedViewModels = sortedViewModel.sorted { $0.title < $1.title }
        
//        CurrenciesInfoService.shared.getPopularCurrencies()
//            .reversed()
//            .forEach { popularCurrency in
//            guard let index = sortedViewModels.firstIndex(where: { currencyViewModel -> Bool in
//                return currencyViewModel.currency == popularCurrency.currency
//            }) else { return }
//            
//            let viewModel = sortedViewModels.remove(at: index)
//            sortedViewModels.insert(viewModel, at: 0)
//        }
        return sortedViewModels
    }
}

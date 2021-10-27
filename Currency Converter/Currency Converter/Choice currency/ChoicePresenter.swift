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
    
    func presentData(response: Choice.Model.Response.ResponseType) {
        switch response {
        case .currencies(let currencies):
            let viewModels = buildViewModels(currencies)
            viewController?.displayData(viewModel: .displayCurrencies(viewModels))
        }
    }
        
    private func buildViewModels(_ currencies: [Currency]) -> [ChoiceCurrencyViewModel] {
        currencies.filter({ $0.currencyName != nil }).map({ .init(currency: $0.currency, title: $0.currencyName!) }).sorted(by: { $0.title < $1.title })
//        var result = [ChoiceCurrencyViewModel]()
//        let validCurrencies = currencies.filter { currency in
//            return info.contains { $0.abbreviation == currency.currency }
//        }
//
//        validCurrencies.forEach { value in
//            let currencyTitle = info.first { $0.abbreviation == value.currency }!.title
//            let viewModel = ChoiceCurrencyViewModel(currency: value.currency,
//                                                    title: currencyTitle)
//            result.append(viewModel)
//        }
//        var sortedViewModels = result.sorted { $0.title < $1.title }
//
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
//        return sortedViewModels
    }
}

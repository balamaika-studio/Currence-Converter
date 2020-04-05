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
        case .currencies(let currencies, let info):
            var result = [ChoiceCurrencyViewModel]()
            let validCurrencies = currencies.filter { currency in
                return info.contains { $0.abbreviation == currency.currency }
            }
            
            validCurrencies.forEach { value in
                let currencyTitle = info.first { $0.abbreviation == value.currency }!.title
                let viewModel = ChoiceCurrencyViewModel(currency: value.currency,
                                                        title: currencyTitle)
                result.append(viewModel)
            }
            let sortedQuotes = result.sorted { $0.title < $1.title }            
            viewController?.displayData(viewModel: .displayCurrencies(sortedQuotes))
        }
    }
    
}

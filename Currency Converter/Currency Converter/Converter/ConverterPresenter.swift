//
//  ConverterPresenter.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/16/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol ConverterPresentationLogic {
    func presentData(response: Converter.Model.Response.ResponseType)
}

class ConverterPresenter: ConverterPresentationLogic {
    weak var viewController: ConverterDisplayLogic?
    
    private var baseCurrency: Currency!
    
    func presentData(response: Converter.Model.Response.ResponseType) {
        switch response {
        case .converterCurrencies(let first, let second):
            baseCurrency = first
            let viewModel = buildConverterViewModel(first, second)
            viewController?.displayData(viewModel: .showConverterViewModel(viewModel))
            
        case .favoriteCurrencies(let currencies):            
            let viewModel = buildFavoriteViewModel(currencies)
            viewController?.displayData(viewModel: .showFavoriteViewModel(viewModel))
            
        case .updateBaseCurrency(let base):
            baseCurrency = base
        }
    }
    
    private func buildFavoriteViewModel(_ favorite: [Currency]) -> [FavoriteConverterViewModel] {
        var viewModels = [FavoriteConverterViewModel]()
                
        favorite.forEach { currency in
            let rate = currency.rate / baseCurrency.rate
            let roundedRate = round(rate * pow(10, 4)) / pow(10, 4)
            let symbol = getSymbol(forCurrencyCode: currency.currency) ?? ""
            let stringRate = "\(roundedRate) \(symbol)"
                        
            let currenciesInfo = CurrenciesInfoService.shared.fetch()
            let title = currenciesInfo.first { $0.abbreviation == currency.currency }!
            
            let viewModel = FavoriteConverterViewModel(currency: currency.currency,
                                                       title: title.title,
                                                       regardingRate: stringRate)
            viewModels.append(viewModel)
        }
        
        return viewModels
    }
    
    private func buildConverterViewModel(_ first: Currency, _ second: Currency) -> ConverterViewModel {
        let aRate = Double(first.rate)
        let bRate = Double(second.rate)
        
        let x = round(bRate / aRate * pow(10, 4)) / pow(10, 4)
        let y = round(aRate / bRate * pow(10, 4)) / pow(10, 4)
        
        let aSymbol = getSymbol(forCurrencyCode: first.currency) ?? "Error"
        let bSymbol = getSymbol(forCurrencyCode: second.currency) ?? "Error"
        
        let firstExchange = Exchange(currency: first.currency,
                             rate: aRate,
                             exchangeRate: x,
                             regardingRate: "\(aSymbol)1=\(bSymbol)\(x)")
        let secondExchange = Exchange(currency: second.currency,
                              rate: bRate,
                              exchangeRate: y,
                              regardingRate: "\(bSymbol)1=\(aSymbol)\(y)")
        return ConverterViewModel(firstExchange: firstExchange,
                                  secondExchange: secondExchange)
    }
    
    private func getSymbol(forCurrencyCode code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        if locale.displayName(forKey: .currencySymbol, value: code) == code {
            let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: code)
        }
        return locale.displayName(forKey: .currencySymbol, value: code)
    }
}

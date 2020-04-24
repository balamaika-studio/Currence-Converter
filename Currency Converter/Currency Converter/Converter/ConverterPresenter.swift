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
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy, HH:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter
    }()
    
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
            
        case .error(let message):
            guard let message = message else { break }
            viewController?.displayData(viewModel: .showError(message: message))
        }
    }
    
    private func buildFavoriteViewModel(_ favorite: [Currency]) -> [FavoriteConverterViewModel] {
        var viewModels = [FavoriteConverterViewModel]()
                
        favorite.forEach { currency in
            let rate = currency.rate / baseCurrency.rate
            let roundedRate = AccuracyManager.shared.formatNumber(rate)
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
        let firstRate = Double(first.rate)
        let secondRate = Double(second.rate)
        
        let firstExchangeRate = AccuracyManager.shared.formatNumber(secondRate / firstRate)
        let secondExchangeRate = AccuracyManager.shared.formatNumber(firstRate / secondRate)
        
        let aSymbol = getSymbol(forCurrencyCode: first.currency) ?? "Error"
        let bSymbol = getSymbol(forCurrencyCode: second.currency) ?? "Error"
        
        let firstExchange = Exchange(currency: first.currency,
                             rate: firstRate,
                             exchangeRate: firstExchangeRate,
                             regardingRate: "\(aSymbol)1=\(bSymbol)\(firstExchangeRate)")
        let secondExchange = Exchange(currency: second.currency,
                              rate: secondRate,
                              exchangeRate: secondExchangeRate,
                              regardingRate: "\(bSymbol)1=\(aSymbol)\(secondExchangeRate)")
        
        let timestamp = UserDefaults.standard.integer(forKey: "updated")
        let updatedTitle = buildUpdatedTitle(from: timestamp)
        
        return ConverterViewModel(firstExchange: firstExchange,
                                  secondExchange: secondExchange,
                                  updated: updatedTitle)
    }
    
    private func getSymbol(forCurrencyCode code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        if locale.displayName(forKey: .currencySymbol, value: code) == code {
            let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: code)
        }
        return locale.displayName(forKey: .currencySymbol, value: code)
    }
    
    private func buildUpdatedTitle(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formattedDate = dateFormatter.string(from: date)
        return "Updated - \(formattedDate)"
    }
}

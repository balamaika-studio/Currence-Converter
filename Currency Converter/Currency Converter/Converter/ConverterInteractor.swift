//
//  ConverterInteractor.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/16/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol ConverterBusinessLogic {
    func makeRequest(request: Converter.Model.Request.RequestType)
}

protocol ConverterDataStore {
    var selectedCurrency: Currency? { get set }
}

class ConverterInteractor: ConverterBusinessLogic, ConverterDataStore {
    var selectedCurrency: Currency?
    
    var presenter: ConverterPresentationLogic?
    var service: ConverterService?
    
    var topCurrency: Currency!
    var bottomCurrency: Currency!
    
    func makeRequest(request: Converter.Model.Request.RequestType) {
        if service == nil {
            service = ConverterService()
        }
        switch request {
        // pass Cube Model
        case .changeCurrency(let currencyName):
            guard let newCurrency = selectedCurrency else { break }
            
            if topCurrency.currency == currencyName {
                topCurrency = newCurrency
            } else {
                bottomCurrency = newCurrency
            }

            presenter?.presentData(response: .converterCurrencies(first: topCurrency,
                                                                  second: bottomCurrency))
        case .loadConverterCurrencies:
            // if there are saved currencies, load them from DB
            // else load USD -> EUR from net
            
            NetworkManager().getQuotes { quotes, error in
                guard let quotes = quotes else { return }
                let standartCurrencies = quotes
                    .filter { $0.currency == "USD" || $0.currency == "EUR" }
                    .sorted(by: { $0.rate > $1.rate })
                
                self.topCurrency = standartCurrencies.first!
                self.bottomCurrency = standartCurrencies.last!
                self.presenter?.presentData(response: .converterCurrencies(first: self.topCurrency,
                                                                            second: self.bottomCurrency))
            }
        }
    }
    
}

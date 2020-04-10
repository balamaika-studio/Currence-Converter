//
//  ExchangeRatesInteractor.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/9/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol ExchangeRatesBusinessLogic {
    func makeRequest(request: ExchangeRates.Model.Request.RequestType)
}

class ExchangeRatesInteractor: ExchangeRatesBusinessLogic {
    
    var presenter: ExchangeRatesPresentationLogic?
    var storage: StorageContext!
    
    var currencies: [RealmCurrency]!
    
    init(storage: StorageContext = try! RealmStorageContext()) {
        self.storage = storage
    }
    
    func makeRequest(request: ExchangeRates.Model.Request.RequestType) {
        let defaultRelatives = ["EUR/USD", "GBP/USD", "USD/JPY", "USD/CHF",
                    "AUD/USD", "USD/CAD", "NZD/USD", "EUR/JPY",
                    "USD/RUB", "EUR/RUB"]
        
        switch request {
        case .configureExchangeRates:
            storage.fetch(RealmCurrency.self, predicate: nil, sorted: nil) {
                self.currencies = $0
            }
            
            storage.fetch(RealmExchangeRate.self, predicate: nil, sorted: nil) { rates in
                if rates.isEmpty {
                    defaultRelatives.forEach { stringRelative in
                        let model = buildRelative(stringRelative)
                        let base = currencies.first { $0.currency == model.base }!
                        let relative = currencies.first { $0.currency == model.relative }!
                        
                        try? storage.create(RealmExchangeRate.self) { rate in
                            rate.base = base
                            rate.relative = relative
                            rate.isSelected = model.isSelected
                        }
                    }
                }
            }
        }
    }
    
    private func buildRelative(_ stringRelative: String) -> Relative {
        let defaultSelectedRelatives = ["EUR/USD", "GBP/USD", "USD/CHF", "NZD/USD",]
        let relatives = stringRelative.split(separator: "/").map { String($0) }
        
        let base = relatives.first!
        let relative = relatives.last!
        let isSelected = defaultSelectedRelatives.contains(stringRelative)
        return Relative(base: base, relative: relative, isSelected: isSelected)
    }
}

struct Relative {
    let base: String
    let relative: String
    let isSelected: Bool
}

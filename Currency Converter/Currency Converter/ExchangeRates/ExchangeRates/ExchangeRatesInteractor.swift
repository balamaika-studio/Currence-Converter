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
    
    var currencies: [RealmCurrencyV2]!
    
    init(storage: StorageContext = try! RealmStorageContext()) {
        self.storage = storage
    }
    
    func makeRequest(request: ExchangeRates.Model.Request.RequestType) {
        switch request {
        case .configureExchangeRates:
            break
//            storage.fetch(RealmCurrencyV2.self, predicate: nil, sorted: nil) {
//                self.currencies = $0
//            }
//
//            storage.fetch(RealmExchangeRateV2.self, predicate: nil, sorted: nil) { rates in
//                if rates.isEmpty {
//                    defaultRelatives.forEach { stringRelative in
//                        let model = buildRelative(stringRelative)
//                        if let base = currencies.first(where: { $0.currency == model.base }),
//                           let relative = currencies.first(where: { $0.currency == model.relative }) {
//                            try? storage.create(RealmExchangeRateV2.self) { rate in
//                                rate.base = base
//                                rate.relative = relative
//                                rate.isSelected = model.isSelected
//                            }
//                        }
//                    }
//                }
//            }
        case .saveSelectedExchangeRates(let rate):
            storage.fetch(RealmCurrencyV2.self, predicate: nil, sorted: nil) {
                self.currencies = $0
            }
            storage.fetch(RealmExchangeRateV2.self, predicate: nil, sorted: nil) { rates in
                if let base = currencies.first(where: { $0.currency == rate.base }),
                   let relative = currencies.first(where: { $0.currency == rate.relative }) {
                    try? storage.create(RealmExchangeRateV2.self) { rate in
                        rate.base = base
                        rate.relative = relative
                        rate.isSelected = true
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

//
//  CurrencyRatesInteractor.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/9/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol CurrencyRatesBusinessLogic {
    func makeRequest(request: CurrencyRates.Model.Request.RequestType)
}

class CurrencyRatesInteractor: CurrencyRatesBusinessLogic {
    
    var presenter: CurrencyRatesPresentationLogic?
    var liveStorage: StorageContext!
    var historicalStorage: StorageContext!

    init(storage: StorageContext = try! RealmStorageContext()) {
        self.liveStorage = storage
        let config: ConfigurationType = .named(name: "historical")
        self.historicalStorage = try! RealmStorageContext(configuration: config)
    }
    
    func makeRequest(request: CurrencyRates.Model.Request.RequestType) {
        switch request {
        case .loadCurrencyRateChanges:
            // TODO: - Refactoring
            liveStorage.fetch(Currency.self, predicate: nil, sorted: nil) { live in
                let relativesPredicate = NSPredicate(format: "isSelected = true")
                liveStorage.fetch(RealmExchangeRate.self, predicate: relativesPredicate, sorted: nil) { relatives in
                    self.historicalStorage.fetch(Currency.self, predicate: nil, sorted: nil) { historical in
                        presenter?.presentData(response: .currencies(live,
                                                                     historical,
                                                                     relatives))
                    }
                }
            }
        }
    }
    
}

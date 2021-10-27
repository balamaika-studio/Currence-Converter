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
    private let liveStorage = JSONDataStoreManager.default(for: ExchangeRatesHistoryResponse.self)
    private let historicalStorage = JSONDataStoreManager.historycalExchangeRatesStore
    
    func makeRequest(request: CurrencyRates.Model.Request.RequestType) {
        switch request {
        case .loadCurrencyRateChanges:
            presenter?.presentData(response: .currencies(liveStorage.state?.quotes ?? [], historicalStorage.state?.quotes ?? [], RealmExchangeRate.all().filter({ $0.isSelected })))
            // TODO: - Refactoring
//            liveStorage.fetch(Currency.self, predicate: nil, sorted: nil) { live in
//                let relativesPredicate = NSPredicate(format: "isSelected = true")
//                liveStorage.fetch(RealmExchangeRate.self, predicate: relativesPredicate, sorted: nil) { relatives in
//                    self.historicalStorage.fetch(Currency.self, predicate: nil, sorted: nil) { historical in
//                        presenter?.presentData(response: .currencies(live,
//                                                                     historical,
//                                                                     relatives))
//                    }
//                }
            //}
        }
    }
    
}

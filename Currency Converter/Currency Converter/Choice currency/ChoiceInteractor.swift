//
//  ChoiceInteractor.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/17/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol ChoiceBusinessLogic {
    func makeRequest(request: Choice.Model.Request.RequestType)
}

protocol ChoiceDataStore {
    var selectedCurrency: Currency? { get set }
}

class ChoiceInteractor: ChoiceBusinessLogic, ChoiceDataStore {
    // MARK: - Data Store
    var selectedCurrency: Currency?
    
    var presenter: ChoicePresentationLogic?
    var storage: StorageContext!
    
    init(storage: StorageContext = try! RealmStorageContext()) {
        self.storage = storage
    }
    
    var currencies: [Currency]!
    
    func makeRequest(request: Choice.Model.Request.RequestType) {
        
        switch request {
        case .loadCurrencies(let isGraphCurrencies, let isCrypto, let oppositeCurrency):
            storage.fetch(RealmCurrency.self, predicate: nil, sorted: nil) { currencies in
                self.currencies = isGraphCurrencies == true ?
                    filterGraphCurrencies(from: currencies) :
                    currencies
                var currencyArray: [CurrencyInfo] = []
                if isCrypto {
                    currencyArray =  CurrenciesInfoService.shared.fetchCrypto()
                } else {
                    currencyArray = CurrenciesInfoService.shared.fetchCurrency()
                }

                self.storage.fetch(RealmPairCurrency.self, predicate: nil, sorted: nil) { cur in

                    self.presenter?.presentData(response: .currencies(self.currencies,
                                                                       currencyArray,
                                                                      cur,
                                                                     oppositeCurrency))
                }
            }
            
        case .chooseCurrency(let viewModel):
            selectedCurrency = currencies.first { $0.currency == viewModel.currency }
        case .filter(let title):
            presenter?.presentData(response: .filter(title: title))
        }
    }
    
    private func filterGraphCurrencies(from currencies: [Currency]) -> [Currency] {
//        let graphCurrencies = CurrenciesInfoService.shared.getGraphSupportedCurrencies()
//        return currencies.filter { currency in
//            graphCurrencies.contains { $0.currency == currency.currency }
//        }
        return currencies
    }
    
}

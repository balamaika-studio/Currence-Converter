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
        case .loadCurrencies:
            storage.fetch(RealmCurrency.self, predicate: nil, sorted: nil) { currencies in
                self.currencies = currencies
                let currenciesInfo = CurrenciesInfoService.shared.fetch()
                self.presenter?.presentData(response: .currencies(currencies, currenciesInfo))
            }
            
        case .chooseCurrency(let viewModel):
            selectedCurrency = currencies.first { $0.currency == viewModel.currency }
        }
    }
    
}

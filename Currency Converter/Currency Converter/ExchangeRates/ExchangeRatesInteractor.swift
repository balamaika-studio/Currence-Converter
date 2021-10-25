//
//  ExchangeRatesInteractor.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/9/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

private extension UserDefaults {
    
    private static let exchangePairsKey = "CurrencyConverter.ExchangePairs"
    private static let selectedExchangePairsKey = "CurrencyConverter.SelectedExchangePairs"
    
    var exchangePairs: [String] {
        get { UserDefaults.standard.object(forKey: Self.exchangePairsKey) as? [String] ?? [] }
        set { UserDefaults.standard.set(newValue, forKey: Self.exchangePairsKey) }
    }
    
    var selectedExchangePairs: [String] {
        get { UserDefaults.standard.object(forKey: Self.selectedExchangePairsKey) as? [String] ?? [] }
        set { UserDefaults.standard.set(newValue, forKey: Self.selectedExchangePairsKey) }
    }
}

protocol ExchangeRatesBusinessLogic {
    func makeRequest(request: ExchangeRates.Model.Request.RequestType)
}

final class ExchangeRatesInteractor: ExchangeRatesBusinessLogic {
    
    var presenter: ExchangeRatesPresentationLogic?
    let currencyStore = JSONDataStoreManager.default(for: ExchangeRatesHistoryResponse.self)
    
    var currencies = [Currency]()
    
    func makeRequest(request: ExchangeRates.Model.Request.RequestType) {
        
        let defaultRelatives = ["EUR/USD", "GBP/USD", "USD/JPY", "USD/CHF",
                    "AUD/USD", "USD/CAD", "NZD/USD", "EUR/JPY",
                    "USD/RUB", "EUR/RUB"]
        
        switch request {
        case .configureExchangeRates:
            currencies = currencyStore.state?.quotes ?? []
            
            //storage.fetch(RealmExchangeRate.self, predicate: nil, sorted: nil) { rates in
            let rates = UserDefaults.standard.exchangePairs
            if rates.isEmpty {
                UserDefaults.standard.exchangePairs = defaultRelatives
                UserDefaults.standard.selectedExchangePairs = ["EUR/USD", "GBP/USD", "USD/CHF", "NZD/USD"]
            }
        //}
        }
    }
    
//    private func buildRelative(_ stringRelative: String) -> Relative {
//        let defaultSelectedRelatives = ["EUR/USD", "GBP/USD", "USD/CHF", "NZD/USD"]
//        let relatives = stringRelative.split(separator: "/").map { String($0) }
//
//        let base = relatives.first!
//        let relative = relatives.last!
//        let isSelected = defaultSelectedRelatives.contains(stringRelative)
//        return Relative(base: base, relative: relative, isSelected: isSelected)
//    }
}

struct Relative {
    let base: String
    let relative: String
    let isSelected: Bool
}

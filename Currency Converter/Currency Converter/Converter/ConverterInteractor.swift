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
    var storage: StorageContext!
    var networkManager: NetworkManager!
    
    var topCurrency: Currency!
    var bottomCurrency: Currency!
    
    init(storage: StorageContext = try! RealmStorageContext()) {
        self.storage = storage
        self.networkManager = NetworkManager()
    }
    
    func makeRequest(request: Converter.Model.Request.RequestType) {
        switch request {
        // pass Cube Model
        case .changeCurrency(let currencyName):
            guard let newCurrency = selectedCurrency else { break }
            
            if topCurrency.currency == currencyName {
                topCurrency = newCurrency
            } else {
                bottomCurrency = newCurrency
            }
            presenter?.presentData(response:
                .converterCurrencies(first: topCurrency,
                                     second: bottomCurrency))
            
        case .updateBaseCurrency(let base):
            presenter?.presentData(response: .updateBaseCurrency(base: base))
            
        case .loadFavoriteCurrencies:
            let predicate = NSPredicate(format: "isFavorite = true")
            storage.fetch(RealmCurrency.self, predicate: predicate, sorted: Sorted(key: "currency")) { favoriteCurrencies in
                presenter?.presentData(response: .favoriteCurrencies(favoriteCurrencies))
            }
            
        case .loadConverterCurrencies:
            // if there are saved currencies, load them from DB
            // else load USD -> EUR from net
            storage.fetch(RealmCurrency.self, predicate: nil, sorted: nil) { currencies in
                print(currencies)

                if currencies.isEmpty {
                    networkManager.getQuotes { quotes, error in
                        guard let quotes = quotes else { return }
                        // save new quotes to realm
                        quotes.forEach { quote in
                            try? self.storage.create(RealmCurrency.self) { currency in
                                currency.currency = quote.currency
                                currency.rate = quote.rate
                            }
                        }
                        self.setupConverter(currencies: quotes)
                    }
                } else {
                    setupConverter(currencies: currencies)
                }
            }
            
        }
    }
    
    private func setupConverter(currencies: [Currency]) {
        let standartCurrencies = currencies
            .filter { $0.currency == "USD" || $0.currency == "EUR" }
            .sorted(by: { $0.rate > $1.rate })

        topCurrency = standartCurrencies.first!
        bottomCurrency = standartCurrencies.last!
        presenter?.presentData(response: .converterCurrencies(first: topCurrency,
                                                              second: bottomCurrency))
    }
}

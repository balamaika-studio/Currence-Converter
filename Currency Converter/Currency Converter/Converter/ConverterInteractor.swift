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

class ConverterInteractor: ConverterBusinessLogic, ChoiceDataStore {
    var selectedCurrency: Currency?
    
    var presenter: ConverterPresentationLogic?
    var storage: StorageContext!
    var historicalStorage: StorageContext!
    var networkManager: NetworkManager!
    
    var topCurrency: Currency!
    var bottomCurrency: Currency!
    var isFirstLoading = true
    var lastTotalSum: Double = 1
    
    init(storage: StorageContext = try! RealmStorageContext()) {
        self.storage = storage
        let config: ConfigurationType = .named(name: "historical")
        self.historicalStorage = try! RealmStorageContext(configuration: config)
        self.networkManager = NetworkManager()
    }
    
    func makeRequest(request: Converter.Model.Request.RequestType) {
        switch request {
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
            
        case .changeBottomCurrency(let newCurrency):
            bottomCurrency = newCurrency
            presenter?.presentData(response: .converterCurrencies(first: topCurrency,
                                                                  second: bottomCurrency))
            
        case .loadFavoriteCurrencies(let total):
            lastTotalSum = total == nil ? lastTotalSum : total!
            let predicate = NSPredicate(format: "isFavorite = true")
            storage.fetch(RealmCurrency.self, predicate: predicate, sorted: Sorted(key: "currency")) { favoriteCurrencies in
                presenter?.presentData(response: .favoriteCurrencies(favoriteCurrencies,
                                                                     total: lastTotalSum))
            }
            
        case .loadConverterCurrencies:
            // if there are saved currencies, load them from DB
            // else load USD -> EUR from net
            storage.fetch(RealmCurrency.self, predicate: nil, sorted: nil) {
                $0.isEmpty ? loadQuotes() : setupConverter(with: $0)
            }
            
        case .updateCurrencies:
            loadQuotes(update: true)
            
        case .remove(let favoriteCurrency):
            update(favoriteCurrency, isFavorite: false)
        }
    }
    
    // MARK: - Private Methods
    private func update(_ favorite: Currency, isFavorite: Bool) {
        let predicate = NSPredicate(format: "currency = %@", favorite.currency)
        storage.fetch(RealmCurrency.self, predicate: predicate, sorted: nil) { result in
            let selectedCurrency = result.first!
            try! storage.update {
                selectedCurrency.isFavorite = isFavorite
            }
        }
    }
    
    private func loadQuotes(update: Bool = false) {
        networkManager.getQuotes { response, errorMessage in            
            guard let quotes = response?.quotes else {
                self.presenter?.presentData(response: .error(errorMessage))
                return
            }
            // save last updated date
            UserDefaults.standard.set(response!.updated, forKey: "updated")
            
            // save/update quotes
            switch update {
            case false: self.createQuotes(quotes, in: self.storage)
            case true: self.updateQuotes(quotes, in: self.storage)
            }
            self.loadHistoricalQuotes()
            self.setupConverter(with: quotes)
        }
    }
    
    private func loadHistoricalQuotes() {
        let dayInSec = 86400
        let timestamp = UserDefaults.standard.integer(forKey: "updated")
        var date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        date.addTimeInterval(-TimeInterval(dayInSec))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringDate = dateFormatter.string(from: date)

        networkManager.getQuotes(date: stringDate) { response, errorMessageerrorMessage in
            guard let quotes = response?.quotes else { return }
            self.historicalStorage.fetch(RealmCurrency.self, predicate: nil, sorted: nil) {
                $0.isEmpty ?
                    self.createQuotes(quotes, in: self.historicalStorage) :
                    self.updateQuotes(quotes, in: self.historicalStorage)
            }
        }
    }
    
    private func createQuotes(_ quotes: [Quote], in realm: StorageContext) {
        quotes.forEach { quote in
            try? realm.create(RealmCurrency.self) { currency in
                currency.currency = quote.currency
                currency.rate = quote.rate
            }
        }
    }
    
    private func updateQuotes(_ quotes: [Quote], in realm: StorageContext) {
        realm.fetch(RealmCurrency.self, predicate: nil, sorted: nil) {
            for currency in $0 {
                let quote = quotes.first { $0.currency == currency.currency }
                guard let newQuote = quote else { return }
                try? realm.update {
                    currency.rate = newQuote.rate
                }
            }
            makeRequest(request: .loadFavoriteCurrencies(total: nil))
        }
    }

    private func setupConverter(with currencies: [Currency]) {
        if isFirstLoading {
            let standartCurrencies = currencies
                .filter { $0.currency == "USD" || $0.currency == "EUR" }
                .sorted(by: { $0.rate > $1.rate })
            
            topCurrency = standartCurrencies.first!
            bottomCurrency = standartCurrencies.last!
            isFirstLoading = false
        }
        
        presenter?.presentData(response: .converterCurrencies(first: topCurrency,
                                                              second: bottomCurrency))
    }
}

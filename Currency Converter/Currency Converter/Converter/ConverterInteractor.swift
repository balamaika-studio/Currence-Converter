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
    var group = DispatchGroup()
    
    init(storage: StorageContext = try! RealmStorageContext()) {
        self.storage = storage
        let config: ConfigurationType = .named(name: "historical")
        self.historicalStorage = try! RealmStorageContext(configuration: config)
        self.networkManager = NetworkManager()
    }
    
    func makeRequest(request: Converter.Model.Request.RequestType) {
        switch request {
        case .firstLoad:
            firstLoad()
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
            topCurrency = base
            presenter?.presentData(response: .updateBaseCurrency(base: base))
            
        case .changeBottomCurrency(let newCurrency):
            break
//            guard bottomCurrency.currency != newCurrency.currency else { break }
//            bottomCurrency = newCurrency
//            presenter?.presentData(response: .converterCurrencies(first: topCurrency,
//                                                                  second: bottomCurrency))
            
        case .loadFavoriteCurrenciesFirst(let total, let index):
            lastTotalSum = total == nil ? lastTotalSum : total!
            let predicate = NSPredicate(format: "isFavorite = true")
            storage.fetch(RealmCurrencyV2.self, predicate: predicate, sorted: Sorted(key: "currency")) { favoriteCurrencies in
                presenter?.presentData(response: .favoriteCurrencies(favoriteCurrencies,
                                                                     total: lastTotalSum,
                                                                     totalIndex: index))
            }
        case .loadFavoriteCurrencies(let total, let index):
            lastTotalSum = total == nil ? lastTotalSum : total!
            let predicate = NSPredicate(format: "isFavorite = true")
            storage.fetch(RealmCurrencyV2.self, predicate: predicate, sorted: Sorted(key: "currency")) { favoriteCurrencies in
                presenter?.presentData(response: .favoriteCurrenciesPartUpdate(favoriteCurrencies,
                                                                     total: lastTotalSum,
                                                                     totalIndex: index))
            }
            
        case .loadCryptoCurrencies:
            // if there are saved currencies, load them from DB
            // else load USD -> EUR from net
            storage.fetch(RealmCurrencyV2.self, predicate: nil, sorted: nil) {
                $0.isEmpty ? loadQuotes(exchangeType: .crypto) : setupConverter(with: $0)
            }

        case .loadConverterCurrencies:
            // if there are saved currencies, load them from DB
            // else load USD -> BTC from net
            storage.fetch(RealmCurrencyV2.self, predicate: nil, sorted: nil) {
                $0.isEmpty ? loadQuotes(exchangeType: .forex) : setupConverter(with: $0)
            }
            
        case .updateCurrencies:
            loadQuotes(update: true, exchangeType: .forex)
            UserDefaultsService.shared.lastUpdateTimeInteraval = Date().timeIntervalSince1970

        case .updateCrypto:
            loadQuotes(update: true, exchangeType: .crypto)
            UserDefaultsService.shared.lastUpdateTimeInteraval = Date().timeIntervalSince1970

        case .remove(let favoriteCurrency):
            update(favoriteCurrency, isFavorite: false)
            
        case .saveFavoriteOrder(let currencies):
            let saved = FavoriteOrderService.shared.fetchOrder()
            if !saved.isEmpty && currencies.isEmpty {
                // dont overwrite saved data with an empty array.
                break
            }
            FavoriteOrderService.shared.saveOrder(currencies)
        }
    }
    
    // MARK: - Private Methods
    private func update(_ favorite: Currency, isFavorite: Bool) {
        let predicate = NSPredicate(format: "currency = %@", favorite.currency)
        storage.fetch(RealmCurrencyV2.self, predicate: predicate, sorted: nil) { result in
            let selectedCurrency = result.first!
            try! storage.update {
                selectedCurrency.isFavorite = isFavorite
            }
        }
    }
    
    private func loadQuotes(update: Bool = false, exchangeType: ExchangeType) {
        networkManager.getQuotes(exchangeType: exchangeType) { response, errorMessage in
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
        networkManager.getQuotes(date: date) { response, errorMessageerrorMessage in
            guard let quotes = response?.quotes else { return }
            self.historicalStorage.fetch(RealmCurrencyV2.self, predicate: nil, sorted: nil) {
                $0.isEmpty ?
                    self.createQuotes(quotes, in: self.historicalStorage) :
                    self.updateQuotes(quotes, in: self.historicalStorage)
            }
        }
    }
    
    private func createQuotes(_ quotes: [Quote], in realm: StorageContext) {
        quotes.forEach { quote in
            try? realm.create(RealmCurrencyV2.self) { currency in
                currency.currency = quote.currency
                currency.rate = quote.rate
                currency.index = quote.index
            }
        }
    }
    
    private func updateQuotes(_ quotes: [Quote], in realm: StorageContext) {
        realm.fetch(RealmCurrencyV2.self, predicate: nil, sorted: nil) {
            for currency in $0 {
                let quote = quotes.first { $0.currency == currency.currency }
                guard let newQuote = quote else { return }
                try? realm.update {
                    currency.rate = newQuote.rate
                    currency.index = newQuote.index
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
    
    private func firstLoad() {
        if UserDefaultsService.shared.isFirstLoad {
            UserDefaults.standard.set(true, forKey: "clearField")
            self.addFirstLoadCurrency()
            UserDefaultsService.shared.isFirstLoad = false
        }
    }
    
//    private func setCurrenciesList(_ response: [CurrencyResponse]?, in realm: StorageContext, exchangeType: ExchangeType) {
//        var currencyArray = [CurrencyInfo]()
//        switch exchangeType {
//        case .forex:
//            currencyArray = CurrenciesInfoService.shared.fetchCurrency()
//        case .crypto:
//            currencyArray = CurrenciesInfoService.shared.fetchCrypto()
//        }
//        
//        response?.forEach { pair in
//            guard let baseAndRelative = pair.symbol?.split(separator: "/").map({ String($0) }),
//                  let id = pair.id,
//                  let base = baseAndRelative.first,
//                  let relative = baseAndRelative.last else {
//                      return
//                  }
//            if currencyArray.contains(where: { el in
//                el.abbreviation == base || el.abbreviation == relative
//            }) {
//                try? realm.create(RealmPairCurrencyV2.self) { currency in
//                    currency.currencyPairId = id
//                    currency.base = base
//                    currency.relative = relative
//                    currency.type = exchangeType
//                }
//            }
//        }
//    }
    
    
    private func addFirstLoadCurrency() {
        let locale = Locale.current
        let currencyCode = locale.currencyCode!
        storage.fetch(RealmCurrencyV2.self, predicate: nil, sorted: nil) {
            let curr = $0.filter { el in
                el.currency == "USD" ||
                el.currency == "EUR" ||
                el.currency == "GBP" ||
                el.currency == "CNY" ||
                el.currency == "JPY" ||
                el.currency == "CHF" ||
                el.currency == "BTC" ||
                el.currency == currencyCode
            }
            curr.forEach { currency in
                update(currency, isFavorite: true)
            }
        }
        makeRequest(request: .updateCurrencies)
        makeRequest(request: .updateCrypto)
        presenter?.presentData(response: .firstLoadComplete)
    }
}

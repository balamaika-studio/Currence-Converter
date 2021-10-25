////
////  ConverterInteractor.swift
////  Currency Converter
////
////  Created by Kiryl Klimiankou on 3/16/20.
////  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
////
//
//import UIKit
//
//protocol ConverterBusinessLogic {
//    func makeRequest(request: Converter.Model.Request.RequestType)
//}
//
//protocol ConverterDataStore {
//    var selectedCurrency: Currency? { get set }
//}
//
//final class ConverterInteractor: ConverterBusinessLogic, ChoiceDataStore {
//
//    typealias Store = AnyJSONDataStore<ExchangeRatesHistoryResponse>
//
//    //var selectedCurrency: Currency?
//    var baseCount: Double = 1 {
//        didSet {
//            presenter?.presentData(response: .updateLocalFavoriteCurrencies(baseCount: baseCount))
//        }
//    }
//
//    var presenter: ConverterPresentationLogic?
//    let store: Store
//    //var historicalStorage: StorageContext!
//    let networkManager: NetworkManager
//
//    //var topCurrency: Currency!
//    //var bottomCurrency: Currency!
//    //var isFirstLoading = true
//    //var lastTotalSum: Double = 1
//
//    init(store: Store = .init(dataStore: FileDataStoreManager.default()), networkManager: NetworkManager = .init()) {
//        self.store = store
//        //let config: ConfigurationType = .named(name: "historical")
//        //self.historicalStorage = try! RealmStorageContext(configuration: config)
//        self.networkManager = networkManager
//    }
//
////    func makeRequest(request: Converter.Model.Request.RequestType) {
////        switch request {
////
////        case let .updateBaseCount(currency, count):
////            baseCount = currency.rate * count
//////        case .changeCurrency(let currencyName):
//////            guard let newCurrency = selectedCurrency else { break }
//////
//////            if topCurrency.currency == currencyName {
//////                topCurrency = newCurrency
//////            } else {
//////                bottomCurrency = newCurrency
//////            }
//////            presenter?.presentData(response:
//////                .converterCurrencies(first: topCurrency,
//////                                     second: bottomCurrency))
//////
//////        case .updateBaseCurrency(let base):
//////            topCurrency = base
//////            presenter?.presentData(response: .updateBaseCurrency(base: base))
//////
//////        case .changeBottomCurrency(let newCurrency):
//////            guard bottomCurrency.currency != newCurrency.currency else { break }
//////            bottomCurrency = newCurrency
//////            presenter?.presentData(response: .converterCurrencies(first: topCurrency,
//////                                                                  second: bottomCurrency))
////
////        case .loadFavoriteCurrencies:
////            let predicate = NSPredicate(format: "isFavorite = true")
////            let dataSource = storage.objects(Currency.self)
////                .filter(predicate)
////                .sorted(by: \.currency, ascending: true)
////            presenter?.presentData(response: .favoriteCurrencies(dataSource, baseCount: baseCount))
//////            storage.fetch(Currency.self, predicate: predicate, sorted: Sorted(key: "currency")) { favoriteCurrencies in
//////                presenter?.presentData(response: .favoriteCurrencies(favoriteCurrencies,
//////                                                                     baseCount: baseCount))
//////            }
////
////        case .loadConverterCurrencies:
////            // if there are saved currencies, load them from DB
////            // else load USD -> EUR from net
////            storage.fetch(Currency.self, predicate: nil, sorted: nil) {
////                if $0.isEmpty {
////                    loadQuotes()
////                }
////                //$0.isEmpty ? loadQuotes() : setupConverter(with: $0)
////            }
////
////        case .updateCurrencies:
////            loadQuotes(update: true)
////
////        case .remove(let favoriteCurrency):
////            update(favoriteCurrency, isFavorite: false)
////
////        case .saveFavoriteOrder(let currencies):
////            let saved = FavoriteOrderService.shared.fetchOrder()
////            if !saved.isEmpty && currencies.isEmpty {
////                // dont overwrite saved data with an empty array.
////                break
////            }
////            FavoriteOrderService.shared.saveOrder(currencies)
////        }
////    }
////
////    // MARK: - Private Methods
////    private func update(_ favorite: Currency, isFavorite: Bool) {
////        let predicate = NSPredicate(format: "currency = %@", favorite.currency)
////        storage.fetch(Currency.self, predicate: predicate, sorted: nil) { result in
////            let selectedCurrency = result.first!
////            try! storage.update {
////                selectedCurrency.isFavorite = isFavorite
////            }
////        }
////    }
////
////    private func loadQuotes() {
////        networkManager.getQuotes { [weak self] response, errorMessage in
////            guard let self = self else { return }
////            guard let quotes = response?.quotes else {
////                self.presenter?.presentData(response: .error(errorMessage))
////                return
////            }
////            // save last updated date
////            UserDefaults.standard.set(response!.updated, forKey: "updated")
////
////            // save/update quotes
////            switch update {
////            case false: self.createQuotes(quotes, in: self.storage)
////            case true: self.updateQuotes(quotes, in: self.storage)
////            }
////            self.loadHistoricalQuotes()
////            self.presenter?.presentData(response: .favoriteCurrencies(quotes, baseCount: self.baseCount))
////            //self.setupConverter(with: quotes)
////        }
////    }
////
////    private func loadHistoricalQuotes() {
////        let dayInSec = 86400
////        let timestamp = UserDefaults.standard.integer(forKey: "updated")
////        var date = Date(timeIntervalSince1970: TimeInterval(timestamp))
////        date.addTimeInterval(-TimeInterval(dayInSec))
////        networkManager.getQuotes(date: date) { response, errorMessage in
////            guard let quotes = response?.quotes else { return }
////            self.historicalStorage.fetch(Currency.self, predicate: nil, sorted: nil) {
////                $0.isEmpty ?
////                    self.createQuotes(quotes, in: self.historicalStorage) :
////                    self.updateQuotes(quotes, in: self.historicalStorage)
////            }
////        }
////    }
////
////    private func createQuotes(_ quotes: [Quote], in realm: StorageContext) {
////        try? realm.create(Currency.self) { currency in
////            quotes.forEach { quote in
////                currency.currency = quote.currency
////                currency.rate = quote.rate
////            }
////        }
////    }
////
////    private func updateQuotes(_ quotes: [Quote], in realm: StorageContext) {
////        realm.fetch(Currency.self, predicate: nil, sorted: nil) { currencies in
////            try? realm.update {
////                for currency in currencies {
////                    guard let quote = quotes.first(where: { $0.currency == currency.currency }) else { return }
////                    currency.rate = quote.rate
////                }
////            }
////            makeRequest(request: .loadFavoriteCurrencies)
////        }
////    }
//
////    private func setupConverter(with currencies: [Currency]) {
////        var _currencies = currencies
////        if isFirstLoading {
////            currencies
////                .filter { $0.currency == "USD" || $0.currency == "EUR" }
////                .sorted(by: { $0.rate > $1.rate })
////
////            //topCurrency = standartCurrencies.first!
////            //bottomCurrency = standartCurrencies.last!
////            isFirstLoading = false
////        }
////
////        presenter?.presentData(response: .favoriteCurrencies(standartCurrencies, total: <#T##Double#>))
////    }
//}

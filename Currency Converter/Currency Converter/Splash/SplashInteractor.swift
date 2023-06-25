//
//  FavoriteCryptocurrencyInteractor.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/26/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol SplashBusinessLogic {
    func makeRequest(request: Splash.Model.Request.RequestType)
}

class SplashInteractor: SplashBusinessLogic {
    var presenter: SplashPresentationLogic?
    var storage: StorageContext!
    var networkManager: NetworkManager!
    
    init(storage: StorageContext = try! RealmStorageContext()) {
        self.storage = storage
        self.networkManager = NetworkManager()
    }
    
    func makeRequest(request: Splash.Model.Request.RequestType) {
        switch request {
        case .loadCurrencies():
            firstLoad()
        }
    }
    
    private func firstLoad() {
        if UserDefaultsService.shared.isFirstLoad {
            let group = DispatchGroup()
            group.enter()
            networkManager.getQuotes(exchangeType: .forex) { response, errorMessage in
                guard let quotes = response?.quotes else {
                    return
                }

                // save/update quotes
                self.createQuotes(quotes, in: self.storage)
                group.leave()
            }
            
            group.enter()
            networkManager.getQuotes(exchangeType: .crypto) { response, errorMessage in
                guard let quotes = response?.quotes else {
                    return
                }

                // save/update quotes
                let currenciesInfo = CurrenciesInfoService.shared.fetchCrypto()
                let filteredQuotes = quotes.filter { quote in
                    currenciesInfo.contains { info in
                        quote.currency == info.abbreviation
                    }
                }

                self.createQuotes(filteredQuotes, in: self.storage)
                group.leave()
            }

            group.notify(queue: .main) {
                self.addFirstLoadCurrency()
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
    
    private func addFirstLoadCurrency() {
        presenter?.presentData(response: .stopLoading())
    }
}


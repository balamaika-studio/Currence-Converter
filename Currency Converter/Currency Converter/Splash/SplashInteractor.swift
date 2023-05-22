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
            networkManager.getAllCurrencies(exchangeType: .forex) { [weak self] response, error in
                guard let strongSelf = self else {
                    return
                }

                strongSelf.setCurrenciesList(response?.response, in: strongSelf.storage, exchangeType: .forex)
                group.leave()
            }

            group.enter()
            networkManager.getAllCurrencies(exchangeType: .crypto) { [weak self] response, error in
                guard let strongSelf = self else {
                    return
                }

                strongSelf.setCurrenciesList(response?.response, in: strongSelf.storage, exchangeType: .crypto)
                group.leave()
            }
            
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
                self.createQuotes(quotes, in: self.storage)
                group.leave()
            }

            group.notify(queue: .main) {
                self.addFirstLoadCurrency()
            }
        }
    }
    
    private func setCurrenciesList(_ response: [CurrencyResponse]?, in realm: StorageContext, exchangeType: ExchangeType) {
        var currencyArray = [CurrencyInfo]()
        switch exchangeType {
        case .forex:
            currencyArray = CurrenciesInfoService.shared.fetchCurrency()
        case .crypto:
            currencyArray = CurrenciesInfoService.shared.fetchCrypto()
        }
        
        response?.forEach { pair in
            guard let baseAndRelative = pair.symbol?.split(separator: "/").map({ String($0) }),
                  let id = pair.id,
                  let base = baseAndRelative.first,
                  let relative = baseAndRelative.last else {
                      return
                  }
            if currencyArray.contains(where: { el in
                el.abbreviation == base || el.abbreviation == relative
            }) {
                try? realm.create(RealmPairCurrencyV2.self) { currency in
                    currency.currencyPairId = id
                    currency.base = base
                    currency.relative = relative
                    currency.type = exchangeType
                }
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


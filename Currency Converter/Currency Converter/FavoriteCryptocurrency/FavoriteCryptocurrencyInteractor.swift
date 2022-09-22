//
//  FavoriteCryptocurrencyInteractor.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/26/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol FavoriteCryptocurrencyBusinessLogic {
    func makeRequest(request: Favorite.Model.Request.RequestType)
}

class FavoriteCryptocurrencyInteractor: FavoriteCryptocurrencyBusinessLogic {
    
    var presenter: FavoriteCryptocurrencyPresentationLogic?
    var storage: StorageContext!
    
    init(storage: StorageContext = try! RealmStorageContext()) {
        self.storage = storage
    }
    
    func makeRequest(request: Favorite.Model.Request.RequestType) {
        switch request {
        case .loadCurrenciesConverter:
            fetchCurrenciesConverter()

        case .loadCurrenciesExchange(let relative, let isLeftSelected):
            fetchCurrenciesExchange(relative: relative, isLeftSelected: isLeftSelected)
            
        case .addFavorite(let model):
            update(model, isFavorite: true)
            presenter?.presentData(response: .update(viewModel: model, isSelected: true))
            
        case .removeFavorite(let model):
            update(model, isFavorite: false)
            let currency = Quote(currency: model.currency, rate: 0, index: 0)
            FavoriteOrderService.shared.removeFromOrder(currency)
            presenter?.presentData(response: .update(viewModel: model, isSelected: false))
            
        case .filter(let title):
            presenter?.presentData(response: .filter(title: title))
        }
    }
    
    private func update(_ favorite: FavoriteViewModel, isFavorite: Bool) {
        let predicate = NSPredicate(format: "currency = %@", favorite.currency)
        storage.fetch(RealmCurrency.self, predicate: predicate, sorted: nil) { result in
            let selectedCurrency = result.first!
            try! storage.update {
                selectedCurrency.isFavorite = isFavorite
            }
        }
    }
    
    private func fetchCurrenciesConverter() {
        storage.fetch(RealmCurrency.self, predicate: nil, sorted: nil) { [weak self] currencies in
            let cryptoCurrencyinfo = CurrenciesInfoService.shared.fetchCrypto()
            self?.storage.fetch(RealmPairCurrency.self, predicate: nil, sorted: nil) { [weak self] cur in
                self?.presenter?.presentData(response: .currenciesConverter(currencies, cryptoCurrencyinfo, cur))
            }
        }
    }

    private func fetchCurrenciesExchange(relative: Relative?, isLeftSelected: Bool) {
        let mainCurrency = (!isLeftSelected ? relative?.base : relative?.relative) ?? ""
        storage.fetch(RealmCurrency.self, predicate: nil, sorted: nil) { [weak self] currencies in
            let currenciesInfo = CurrenciesInfoService.shared.fetchCrypto()
            self?.storage.fetch(RealmPairCurrency.self, predicate: nil, sorted: nil) { [weak self] cur in

                self?.presenter?.presentData(response: .currenciesExchange(currencies, currenciesInfo, cur, mainCurrency))
            }
        }
    }
}


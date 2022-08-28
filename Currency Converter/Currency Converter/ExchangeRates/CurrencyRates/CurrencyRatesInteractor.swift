//
//  CurrencyRatesInteractor.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/9/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol CurrencyRatesBusinessLogic {
    func makeRequest(request: CurrencyRates.Model.Request.RequestType)
}

class CurrencyRatesInteractor: CurrencyRatesBusinessLogic {
    
    var presenter: CurrencyRatesPresentationLogic?
    var liveStorage: StorageContext!
    var historicalStorage: StorageContext!
    var networkManager: NetworkManager!
    var candleResponse: [CandleResponse] = []

    init(storage: StorageContext = try! RealmStorageContext()) {
        self.liveStorage = storage
        let config: ConfigurationType = .named(name: "historical")
        self.historicalStorage = try! RealmStorageContext(configuration: config)
        self.networkManager = NetworkManager()
    }

    // MARK: - Private methods

    private func loadHistory(currencies: [String]) {
        candleResponse = []
        let group = DispatchGroup()

        group.enter()
        networkManager.getLastChangeForex(
            type: .forex,
            currencies: currencies) { [weak self] response, error in
                self?.candleResponse.append(contentsOf: response?.response ?? [])
                group.leave()
            }
        
        group.enter()
        networkManager.getLastChangeCrypto(
            type: .forex,
            currencies: currencies) { [weak self] response, error in
                self?.candleResponse.append(contentsOf: response?.response ?? [])
                group.leave()
            }

        group.notify(queue: .main) { [weak self] in
            self?.presenter?.presentData(response: .createViewModel(self?.candleResponse ?? []))
        }
    }

    private func delete(_ relative: CurrencyPairViewModel) {
        let relativesPredicate = NSPredicate(format: "isSelected = true")
        liveStorage.fetch(RealmExchangeRate.self, predicate: relativesPredicate, sorted: nil) {
            $0.forEach { relativeCur in
                if (relativeCur.base?.currency == relative.leftCurrency || relativeCur.base?.currency  == relative.rightCurrency)
                    && (relativeCur.relative?.currency == relative.leftCurrency || relativeCur.relative?.currency == relative.rightCurrency) {
                    try? liveStorage.delete(object: relativeCur)
                }
            }
        }
    }
    
    func makeRequest(request: CurrencyRates.Model.Request.RequestType) {
        switch request {
        case .loadCurrencyRateChanges:
                let relativesPredicate = NSPredicate(format: "isSelected = true")
                liveStorage.fetch(RealmExchangeRate.self, predicate: relativesPredicate, sorted: nil) { relatives in
                    var currencies: [String] = []
                    for relative in relatives {
                        guard let base = relative.base,
                            let relative = relative.relative else { continue }

                        let relation = "\(base.currency)/\(relative.currency)"
                        let revertedRelation = "\(relative.currency)/\(base.currency)"
                        currencies.append(revertedRelation)
                        currencies.append(relation)
                    }
                    loadHistory(currencies: currencies)
            }
        case .addRelative(let relative):
            break

        case .removeRelative(let relative):
            delete(relative)
        }
    }
    
}

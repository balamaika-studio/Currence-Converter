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

    private func loadHistory(currencies: [ShowCurrencyModel]) {
        candleResponse = []
        let group = DispatchGroup()

        group.enter()
        networkManager.getLastChangeForex(
            type: .forex,
            currencies: currencies.map{$0.id ?? ""}) { [weak self] response, error in
                self?.candleResponse.append(contentsOf: response?.response ?? [])
                group.leave()
            }
        
        group.enter()
        networkManager.getLastChangeCrypto(
            type: .forex,
            currencies: currencies.map{$0.id ?? ""}) { [weak self] response, error in
                self?.candleResponse.append(contentsOf: response?.response ?? [])
                group.leave()
            }

        group.notify(queue: .main) { [weak self] in
            var responses: [CandleResponse] = []
            self?.candleResponse.forEach({ response in
                let pairModelIsReverted = currencies.first { cur in
                    cur.id == response.id
                }?.isReverted
                let result = response
                result.isReverted = pairModelIsReverted
                responses.append(result)
            })

            var resultResp = currencies.compactMap { order in
                responses.first(where: { $0.id == order.id })
            }
            resultResp.reverse()
            self?.presenter?.presentData(response: .createViewModel(resultResp))
        }
    }

    private func delete(_ relative: CurrencyPairViewModel) {
        let relativesPredicate = NSPredicate(format: "isSelected = true")
        liveStorage.fetch(RealmExchangeRateV2.self, predicate: relativesPredicate, sorted: nil) {
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
            var pairsModels: [RealmPairCurrencyV2] = []
            liveStorage.fetch(RealmPairCurrencyV2.self, predicate: nil, sorted: nil) { pairs in
                pairsModels = pairs
            }
                let relativesPredicate = NSPredicate(format: "isSelected = true")
                liveStorage.fetch(RealmExchangeRateV2.self, predicate: relativesPredicate, sorted: nil) { relatives in
                    var currencies: [ShowCurrencyModel] = []
                    for relative in relatives {
                        guard let base = relative.base,
                            let relative = relative.relative else { continue }
                        if let pairModel = pairsModels.first(where: { curPair in
                            (curPair.base == base.currency && curPair.relative == relative.currency) ||
                            (curPair.base == relative.currency && curPair.relative == base.currency)
                        }) {
                            if pairModel.base == base.currency {
                                currencies.append(ShowCurrencyModel(id: pairModel.currencyPairId, isReverted: false))
                            } else {
                                currencies.append(ShowCurrencyModel(id: pairModel.currencyPairId, isReverted: true))
                            }
                        }
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

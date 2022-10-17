//
//  CurrencySelectionInteractor.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/9/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol CurrencySelectionBusinessLogic {
    func makeRequest(request: CurrencySelection.Model.Request.RequestType)
}

class CurrencySelectionInteractor: CurrencySelectionBusinessLogic {
    
    var presenter: CurrencySelectionPresentationLogic?
    var storage: StorageContext!
    
    init(storage: StorageContext = try! RealmStorageContext()) {
        self.storage = storage
    }
    
    func makeRequest(request: CurrencySelection.Model.Request.RequestType) {
        switch request {
        case .loadRelatives:
            storage.fetch(RealmExchangeRateV2.self, predicate: nil, sorted: nil) {
                presenter?.presentData(response: .relatives($0))
            }
            
        case .addRelative(let relative):
            update(relative, isSelected: true)
            
        case .removeRelative(let relative):
            update(relative, isSelected: false)
        }
    }
    
    private func update(_ relative: CurrencyPairViewModel, isSelected: Bool) {
        let realmId = NSPredicate(format: "id = %@", relative.realmId)
        storage.fetch(RealmExchangeRateV2.self, predicate: realmId, sorted: nil) {
            guard let exchangeRate = $0.first else { return }
            try? storage.update {
                exchangeRate.isSelected = isSelected
            }
        }
    }
}

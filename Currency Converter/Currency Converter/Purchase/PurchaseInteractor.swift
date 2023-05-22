//
//  FavoriteCryptocurrencyInteractor.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/26/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol PurchaseBusinessLogic {
    func makeRequest(request: Purchase.Model.Request.RequestType)
}

class PurchaseInteractor: PurchaseBusinessLogic {
    var presenter: PurchasePresentationLogic?
    var storage: StorageContext!
    var networkManager: NetworkManager!
    
    init(storage: StorageContext = try! RealmStorageContext()) {
        self.storage = storage
        self.networkManager = NetworkManager()
    }
    
    func makeRequest(request: Purchase.Model.Request.RequestType) {
        switch request {
        case .purchases:
            ConverterProducts.store.requestProducts{ [weak self] helper, success, products in
                guard let self = self else { return }
                let products = products ?? []
                
                if success  {
                    self.presenter?.presentData(response: .products(products))
                    helper.update(products: products)
                }
            }
        }
    }
}


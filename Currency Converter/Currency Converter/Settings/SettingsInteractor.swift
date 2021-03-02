//
//  SettingsInteractor.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/20/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol SettingsBusinessLogic {
    func makeRequest(request: Settings.Model.Request.RequestType)
}

class SettingsInteractor: SettingsBusinessLogic {
    
    var presenter: SettingsPresentationLogic?
    
    func makeRequest(request: Settings.Model.Request.RequestType) {
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

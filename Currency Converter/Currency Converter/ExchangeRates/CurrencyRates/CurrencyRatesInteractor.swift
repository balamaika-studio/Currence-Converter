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
    var service: CurrencyRatesService?
    
    func makeRequest(request: CurrencyRates.Model.Request.RequestType) {
        if service == nil {
            service = CurrencyRatesService()
        }
    }
    
}

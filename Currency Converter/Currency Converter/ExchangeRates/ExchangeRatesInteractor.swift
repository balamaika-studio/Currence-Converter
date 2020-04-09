//
//  ExchangeRatesInteractor.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/9/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol ExchangeRatesBusinessLogic {
    func makeRequest(request: ExchangeRates.Model.Request.RequestType)
}

class ExchangeRatesInteractor: ExchangeRatesBusinessLogic {
    
    var presenter: ExchangeRatesPresentationLogic?
    var service: ExchangeRatesService?
    
    func makeRequest(request: ExchangeRates.Model.Request.RequestType) {
        if service == nil {
            service = ExchangeRatesService()
        }
    }
    
}

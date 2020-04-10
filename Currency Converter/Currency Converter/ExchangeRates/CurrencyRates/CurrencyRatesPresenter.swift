//
//  CurrencyRatesPresenter.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/9/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol CurrencyRatesPresentationLogic {
    func presentData(response: CurrencyRates.Model.Response.ResponseType)
}

class CurrencyRatesPresenter: CurrencyRatesPresentationLogic {
    weak var viewController: CurrencyRatesDisplayLogic?
    
    func presentData(response: CurrencyRates.Model.Response.ResponseType) {
        
    }
    
}

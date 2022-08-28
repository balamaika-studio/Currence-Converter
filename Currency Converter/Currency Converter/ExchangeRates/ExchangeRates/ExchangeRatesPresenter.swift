//
//  ExchangeRatesPresenter.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/9/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol ExchangeRatesPresentationLogic {
    func presentData(response: ExchangeRates.Model.Response.ResponseType)
}

class ExchangeRatesPresenter: ExchangeRatesPresentationLogic {
    weak var viewController: UIViewController?
    
    func presentData(response: ExchangeRates.Model.Response.ResponseType) {
        
    }
}

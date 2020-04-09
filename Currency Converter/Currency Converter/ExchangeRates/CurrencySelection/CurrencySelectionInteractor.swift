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
    var service: CurrencySelectionService?
    
    func makeRequest(request: CurrencySelection.Model.Request.RequestType) {
        if service == nil {
            service = CurrencySelectionService()
        }
    }
    
}

//
//  ConverterInteractor.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/16/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol ConverterBusinessLogic {
    func makeRequest(request: Converter.Model.Request.RequestType)
}

class ConverterInteractor: ConverterBusinessLogic {
    
    var presenter: ConverterPresentationLogic?
    var service: ConverterService?
    
    func makeRequest(request: Converter.Model.Request.RequestType) {
        if service == nil {
            service = ConverterService()
        }
    }
    
}

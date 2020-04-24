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
    var service: SettingsService?
    
    func makeRequest(request: Settings.Model.Request.RequestType) {
        if service == nil {
            service = SettingsService()
        }
    }
    
}

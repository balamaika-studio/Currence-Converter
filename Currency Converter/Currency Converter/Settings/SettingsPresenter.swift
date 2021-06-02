//
//  SettingsPresenter.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/20/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol SettingsPresentationLogic {
    func presentData(response: Settings.Model.Response.ResponseType)
}

class SettingsPresenter: SettingsPresentationLogic {
    weak var viewController: SettingsDisplayLogic?
    
    func presentData(response: Settings.Model.Response.ResponseType) {
        switch response {
        case .products(let products):
            viewController?.displayData(viewModel: .products(products))
        }
    }
    
}

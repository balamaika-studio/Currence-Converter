//
//  CurrencySelectionPresenter.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/9/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol CurrencySelectionPresentationLogic {
    func presentData(response: CurrencySelection.Model.Response.ResponseType)
}

class CurrencySelectionPresenter: CurrencySelectionPresentationLogic {
    weak var viewController: CurrencySelectionDisplayLogic?
    
    func presentData(response: CurrencySelection.Model.Response.ResponseType) {
        switch response {
        case .relatives(let relatives):
            viewController?.displayData(viewModel: .showRelatives(relatives))
        }
    }
    
}

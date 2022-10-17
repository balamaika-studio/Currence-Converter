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
            let viewModels = buildCurrencySelectionViewModels(exchangeRates: relatives)
            viewController?.displayData(viewModel: .showRelatives(viewModels))
        }
    }
    
    private func buildCurrencySelectionViewModels(exchangeRates: [RealmExchangeRateV2]) -> [CurrencySelectionViewModel] {
        var result = [CurrencySelectionViewModel]()
        
        for exchangeRate in exchangeRates {
            guard let base = exchangeRate.base,
                let relative = exchangeRate.relative else { continue }
            
//            let relation = "\(base.currency)/\(relative.currency)"
            let viewModel = CurrencySelectionViewModel(id: exchangeRate.id,
                                                       leftCurrency: base.currency,
                                                       rightCurrency: relative.currency,
                                                       isSelected: exchangeRate.isSelected)
            result.append(viewModel)
        }
        return result
    }
    
}

//
//  GraphPresenter.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/17/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol GraphPresentationLogic {
    func presentData(response: Graph.Model.Response.ResponseType)
}

class GraphPresenter: GraphPresentationLogic {
    weak var viewController: GraphDisplayLogic?
    
    func presentData(response: Graph.Model.Response.ResponseType) {
        switch response {
        case .graphPeriods(let periods):
            viewController?.displayData(viewModel: .showGraphPeriods(periods))
            
        case .defaultConverter(let converterModel):
            viewController?.displayData(viewModel: .showGraphConverter(converterModel))
            
        case .newConverterCurrency(let currency):
            guard let model = buildNewModel(with: currency) else { break }
            viewController?.displayData(viewModel: .updateConverter(newModel: model))
        }
    }
    
    private func buildNewModel(with currency: Currency) -> ChoiceCurrencyViewModel? {
        guard
            let info = CurrenciesInfoService.shared.getInfo(by: currency) else {
                return nil
        }
        return ChoiceCurrencyViewModel(currency: info.abbreviation, title: info.title)
    }
}

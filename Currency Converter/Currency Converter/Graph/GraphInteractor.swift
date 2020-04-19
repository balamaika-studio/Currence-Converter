//
//  GraphInteractor.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/17/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol GraphBusinessLogic {
    func makeRequest(request: Graph.Model.Request.RequestType)
}

class GraphInteractor: GraphBusinessLogic, ChoiceDataStore {
    var selectedCurrency: Currency?
    var presenter: GraphPresentationLogic?
    
    func makeRequest(request: Graph.Model.Request.RequestType) {
        switch request {
        case .getGraphPeriods:
            let periods = PeriodService.shared.buildGraphPeriodModels()
            presenter?.presentData(response: .graphPeriods(periods))
            
        case .getDefaultConverter:
            let converter = defaultConverter()
            presenter?.presentData(response: .defaultConverter(converter))
            
        case .updateConverterCurrency:
            guard let newCurrency = selectedCurrency else { break }
            presenter?.presentData(response: .newConverterCurrency(newCurrency))
        }
        
    }
    
    private func defaultConverter() -> GraphConverterViewModel {
        let base = ChoiceCurrencyViewModel(currency: "USD", title: "United States Dollar")
        let relative = ChoiceCurrencyViewModel(currency: "EUR", title: "Euro")
        return GraphConverterViewModel(base: base, relative: relative)
    }
}

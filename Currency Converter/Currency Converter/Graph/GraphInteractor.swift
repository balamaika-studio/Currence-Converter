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
    var networkManager: NetworkManager!
    
    init() {
        self.networkManager = NetworkManager()
    }
    
    func makeRequest(request: Graph.Model.Request.RequestType) {
        switch request {
        case .getGraphPeriods:
            let periods = PeriodService.shared.buildGraphPeriodModels()
            presenter?.presentData(response: .graphPeriods(periods))
            
        case .getDefaultConverter:
            let converter = CurrenciesInfoService.shared.getGraphDefaultCurrencies()
            presenter?.presentData(response: .defaultConverter(converter))
            
        case .updateConverterCurrency:
            guard let newCurrency = selectedCurrency else { break }
            presenter?.presentData(response: .newConverterCurrency(newCurrency))
            
        case .loadGraphData(let base, let relative, let period):
            let interval = buildGraphRequestInterval(period: period)
            networkManager.getQuotes(base: base, currencies: [relative], start: interval.startDate, end: interval.endDate) { response, errorMessage in
                guard let answer = response?.quotes else {
                    print(errorMessage ?? "Error Load graph data")
                    return
                }
                self.presenter?.presentData(response: .graphData(answer.sorted(by: <),
                                                                 period: period))
            }
        }
        
    }
    
    private func buildGraphRequestInterval(period: GraphPeriod) -> GraphPeriodInterval {
        let startInterval = period.interval
        let startDate = Date(timeIntervalSinceNow: TimeInterval(-startInterval))
        let endDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let start = dateFormatter.string(from: startDate)
        let end = dateFormatter.string(from: endDate)
        return GraphPeriodInterval(startDate: start, endDate: end)
    }
}

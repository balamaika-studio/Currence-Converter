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
            
        case .graphData(let timeframeQuotes):
            let viewModel = buildGraphViewModel(timeframeQuotes)
            viewController?.displayData(viewModel: .showGraphData(viewModel))
        }
    }
    
    private func buildNewModel(with currency: Currency) -> ChoiceCurrencyViewModel? {
        guard let info = CurrenciesInfoService.shared.getInfo(by: currency) else {
            return nil
        }
        return ChoiceCurrencyViewModel(currency: info.abbreviation, title: info.title)
    }
    
    private func buildGraphViewModel(_ quotes: [TimeFrameQuote]) -> GraphViewModel {
        let monthsAndDays = quotes
            .map { $0.date }
            .map { date -> [String] in
                let dateComponents = date.split(separator: "-").map { String($0) }
                return dateComponents.filter { $0.count == 2 }
            }
        let dates = monthsAndDays.map { $0.joined(separator: ".") }
        let labels = (0...dates.count).compactMap { Double($0) }
        let data = quotes.map { $0.rate }
        
        return GraphViewModel(labels: labels, data: data, dates: dates)
    }
}

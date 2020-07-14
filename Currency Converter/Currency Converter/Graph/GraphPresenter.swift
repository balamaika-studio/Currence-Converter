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
    private var graphPeriod: GraphPeriod!
    
    func presentData(response: Graph.Model.Response.ResponseType) {
        switch response {
        case .graphPeriods(let periods):
            viewController?.displayData(viewModel: .showGraphPeriods(periods))
            
        case .defaultConverter(let converterModel):
            viewController?.displayData(viewModel: .showGraphConverter(converterModel))
            
        case .newConverterCurrency(let currency):
            guard let model = buildNewModel(with: currency) else { break }
            viewController?.displayData(viewModel: .updateConverter(newModel: model))
            
        case .graphData(let timeframeQuotes, let graphPeriod):
            self.graphPeriod = graphPeriod
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
        guard let period = Period(rawValue: graphPeriod.interval) else {
            fatalError()
        }
        
        var dates = [String]()
        let data = quotes.map { $0.rate }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let responseDates = quotes.compactMap { dateFormatter.date(from: $0.date) }
                        
        switch period {
        case .week: fallthrough
        case .halfMonth: fallthrough
        case .month:
            dateFormatter.dateFormat = "dd.MM"
            dates = responseDates.compactMap { dateFormatter.string(from: $0) }

        default:
            dateFormatter.dateFormat = "LLL"
            dates = responseDates.compactMap { dateFormatter.string(from: $0) }
        }
        
        return GraphViewModel(data: data, dates: dates)
    }
}

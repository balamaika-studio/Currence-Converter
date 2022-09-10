//
//  GraphCryptoPresenter.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/17/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol GraphCryptoPresentationLogic {
    func presentData(response: GraphCrypto.Model.Response.ResponseType)
}

class GraphCryptoPresenter: GraphCryptoPresentationLogic {
    weak var viewController: GraphCryptoDisplayLogic?
    private var GraphCryptoPeriod: GraphPeriod!
    
    func presentData(response: GraphCrypto.Model.Response.ResponseType) {
        switch response {
        case .GraphCryptoPeriods(let periods):
            viewController?.displayData(viewModel: .showGraphCryptoPeriods(periods))
            
        case .defaultConverter(let converterModel):
            viewController?.displayData(viewModel: .showGraphCryptoConverter(converterModel))
            
        case .newConverterCurrency(let currency):
            guard let model = buildNewModel(with: currency) else { break }
            viewController?.displayData(viewModel: .updateConverter(newModel: model))
            
        case .GraphCryptoData(let timeframeQuotes, let GraphCryptoPeriod):
            self.GraphCryptoPeriod = GraphCryptoPeriod
            let viewModel = buildGraphCryptoViewModel(timeframeQuotes)
            viewController?.displayData(viewModel: .showGraphCryptoData(viewModel))
        }
    }
    
    private func buildNewModel(with currency: Currency) -> ChoiceCurrencyViewModel? {
        _ = CurrenciesInfoService.shared.fetchCrypto()
        guard let info = CurrenciesInfoService.shared.getInfo(by: currency) else {
            return nil
        }
        return ChoiceCurrencyViewModel(currency: info.abbreviation, title: info.title)
    }
    
    private func buildGraphCryptoViewModel(_ quotes: [TimeFrameQuote]) -> GraphViewModel {
        guard let period = Period(rawValue: GraphCryptoPeriod.interval) else {
            fatalError()
        }
        
        var dates = [String]()
        let data = quotes.map { $0.rate }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let responseDates = quotes.compactMap {
            Date(timeIntervalSince1970: Double($0.date) ?? 0)
        }
                        
        switch period {
        case .week: fallthrough
        case .halfMonth: fallthrough
        case .month:
            dateFormatter.dateFormat = "dd.MM"
            dates = responseDates.compactMap { dateFormatter.string(from: $0) }

        default:
            dateFormatter.dateFormat = "MM.YY"
            dates = responseDates.compactMap { dateFormatter.string(from: $0) }
        }
        
        return GraphViewModel(data: data, dates: dates)
    }
}

//
//  CurrencyRatesPresenter.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/9/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol CurrencyRatesPresentationLogic {
    func presentData(response: CurrencyRates.Model.Response.ResponseType)
}

class CurrencyRatesPresenter: CurrencyRatesPresentationLogic {
    weak var viewController: CurrencyRatesDisplayLogic?
    
    func presentData(response: CurrencyRates.Model.Response.ResponseType) {
        switch response {
        case .currencies(let live, let historical, let relatives):
            let viewModels = buildViewModels(live, historical, relatives)
            viewController?.displayData(viewModel: .showCurrencyRatesViewModel(viewModels))
        }
    }
    
    
    private func buildViewModels(_ live: [Currency],
                                 _ historical: [Currency],
                                 _ exchangeRates: [RealmExchangeRate]) -> [CurrencyRatesViewModel] {
        var result = [CurrencyRatesViewModel]()
        guard live.count == historical.count else { return result }
        
        for exchangeRate in exchangeRates {
            guard let base = exchangeRate.base,
                let relative = exchangeRate.relative else { continue }
            
            let relation = "\(base.currency)/\(relative.currency)"
            let change = calculateChange(exchangeRate: exchangeRate,
                                         historical: historical)
            let rate = base.rate / relative.rate
            let roundedRate = AccuracyManager.shared.formatNumber(rate)
            
            let viewModel = CurrencyRatesViewModel(relation: relation,
                                                   change: change,
                                                   rate: roundedRate)
            result.append(viewModel)
        }
        return result
    }
    
    private func calculateChange(exchangeRate: RealmExchangeRate,
                                 historical: [Currency]) -> Change {
        var change: Change = .stay
        guard let base = exchangeRate.base,
            let relative = exchangeRate.relative else { fatalError() }
        
        let currentRate = base.rate / relative.rate
        
        let historicalBase = historical.first { $0.currency == base.currency }!
        let historicalRelative = historical.first { $0.currency == relative.currency }!
        
        let historicalRate = historicalBase.rate / historicalRelative.rate
        
        if currentRate > historicalRate {
            change = .increase
        } else if currentRate < historicalRate {
            change = .drop
        }
        return change
    }
}

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
//            let viewModels = buildViewModels(live, historical, relatives)
//            viewController?.displayData(viewModel: .showCurrencyRatesViewModel(viewModels))
            break
        case .createViewModel(let response):
            let viewModels = buildViewModels(response)
            viewController?.displayData(viewModel: .showCurrencyRatesViewModel(viewModels))
        }
    }
    
    
//    private func buildViewModels(_ live: [RealmCurrency],
//                                 _ historical: [RealmCurrency],
//                                 _ exchangeRates: [RealmExchangeRate]) -> [CurrencyRatesViewModel] {
//        var result = [CurrencyRatesViewModel]()
//        guard live.count == historical.count else { return result }
//
//        for exchangeRate in exchangeRates {
//            guard let base = exchangeRate.base,
//                let relative = exchangeRate.relative else { continue }
//
//            let relation = "\(base.currency)/\(relative.currency)"
//            let change = calculateChange(exchangeRate: exchangeRate,
//                                         historical: historical)
//            let rate = base.rate / relative.rate
//            let roundedRate = AccuracyManager.shared.formatNumber(rate)
//
//            let viewModel = CurrencyRatesViewModel(relation: relation,
//                                                   change: change,
//                                                   rate: roundedRate)
//            result.append(viewModel)
//        }
//        return result
//    }

    private func buildViewModels(_ response: [CandleResponse]) -> [CurrencyRatesViewModel] {
        var result = [CurrencyRatesViewModel]()
//        guard live.count == historical.count else { return result }

        for exchangeRate in response {
            guard let relation = exchangeRate.s,
                  let roundedRate = exchangeRate.ch else {
                      return result
                  }

            let curArray = relation.components(separatedBy: "/")
            let change = calculateChange(exchangeRate: Decimal(string: roundedRate) ?? 0)

            let viewModel = CurrencyRatesViewModel(leftCurrency: curArray.first!,
                                                   rightCurrency: curArray.last!,
                                                   change: change,
                                                   rate: roundedRate)
            if !result.contains(where: { model in
                (model.rightCurrency == viewModel.rightCurrency && model.leftCurrency == viewModel.leftCurrency)
                || (model.rightCurrency == viewModel.leftCurrency && model.leftCurrency == viewModel.rightCurrency)
            }) {
                result.append(viewModel)
            }
        }
        return result
    }
    
    private func calculateChange(exchangeRate: Decimal) -> Change {
        var change: Change = .stay
//        guard let base = exchangeRate.base,
//            let relative = exchangeRate.relative else { fatalError() }
//
//        let currentRate = base.rate / relative.rate
//
//        let historicalBase = historical.first { $0.currency == base.currency }!
//        let historicalRelative = historical.first { $0.currency == relative.currency }!
//
//        let historicalRate = historicalBase.rate / historicalRelative.rate
//
//        if currentRate > historicalRate {
//            change = .increase
//        } else if currentRate < historicalRate {
//            change = .down
//        }
        if exchangeRate > 0 {
            change = .increase
        } else if exchangeRate < 0 {
            change = .down
        }

        return change
    }
}

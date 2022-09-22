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
        for exchangeRate in response {
            guard let relation = exchangeRate.s,
                  let lastPrice = exchangeRate.c,
                  let roundedRate = exchangeRate.ch else {
                      return result
                  }

            var rate: String = ""
            if exchangeRate.isReverted ?? false {
                if let decimalRate = Double(lastPrice) {
                    rate = AccuracyManager.shared.formatNumber(1 / decimalRate)
                }
            } else {
                if let decimalRate = Double(lastPrice) {
                    rate = AccuracyManager.shared.formatNumber(decimalRate)
                }
            }

            let curArray = relation.components(separatedBy: "/")
            let change = calculateChange(exchangeRate: Decimal(string: roundedRate) ?? 0, isReverted: exchangeRate.isReverted ?? false)

            let viewModel = CurrencyRatesViewModel(leftCurrency: (exchangeRate.isReverted ?? false) ? curArray.last! : curArray.first!,
                                                   rightCurrency: (exchangeRate.isReverted ?? false) ? curArray.first! : curArray.last!,
                                                   change: change,
                                                   rate: rate)
            if !result.contains(where: { model in
                (model.rightCurrency == viewModel.rightCurrency && model.leftCurrency == viewModel.leftCurrency)
            }) {
                result.append(viewModel)
            }
        }
        return result
    }
    
    private func calculateChange(exchangeRate: Decimal, isReverted: Bool) -> Change {
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
        if (exchangeRate > 0 && !isReverted) || (exchangeRate < 0 && isReverted) {
            change = .increase
        } else if (exchangeRate < 0 && !isReverted) || (exchangeRate > 0 && isReverted) {
            change = .down
        }

        return change
    }
}

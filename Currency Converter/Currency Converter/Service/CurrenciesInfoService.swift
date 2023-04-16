//
//  CurrenciesInfoService.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/2/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

class CurrenciesInfoService {
    static let shared = CurrenciesInfoService()
    
    private var currencyInfo: [CurrencyInfo]!
//    private let graphSupportedSymbols = [
//        "CAD", "HKD", "ISK", "PHP", "DKK", "HUF", "CZK", "GBP", "RON",
//        "SEK", "IDR", "INR", "BRL", "RUB", "HRK", "JPY", "THB", "CHF",
//        "EUR", "MYR", "BGN", "TRY", "CNY", "NOK", "NZD", "ZAR", "USD",
//        "MXN", "SGD", "AUD", "ILS", "KRW", "PLN"
//    ]
    private let popularCurrencies = ["USD", "EUR", "GBP", "CHF", "JPY", "CNY"]
    private let graphDefaultCurrencies = ["USD", "EUR"]
    private let graphDefaultCryptocurrencies = ["BTC", "ETH"]
    private let freeCrypto = ["BTC", "ETH", "LTC", "XRP"]
    
    private init() { }
    
    /// load data from json
    func fetchCurrency() -> [CurrencyInfo] {
        let path = Bundle.main.path(forResource: "currenciesNames", ofType: ".json")!
        let fileUrl = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: fileUrl, options: .mappedIfSafe)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: String]

        var result = [CurrencyInfo]()
        json.forEach { code, _ in
            guard let title = getTitle(for: code) else { return }
            let model = CurrencyInfo(abbreviation: code, title: title, isFree: true)
            result.append(model)
        }
        currencyInfo = result
        return currencyInfo
    }

    func fetchCrypto() -> [CurrencyInfo] {
        let path = Bundle.main.path(forResource: "cryptocurrenciesNames", ofType: ".json")!
        let fileUrl = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: fileUrl, options: .mappedIfSafe)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: String]

        var result = [CurrencyInfo]()
        json.forEach { code, name in
            var isFree = false
            if freeCrypto.contains(where: { crypto in
                crypto == code
            }) {
                isFree = true
            }
            let model = CurrencyInfo(abbreviation: code, title: name, isFree: isFree)
            result.append(model)
        }
        result.sort {
            $0.isFree && !$1.isFree
        }
        currencyInfo = result
        return currencyInfo
    }
    
    func getInfo(by currency: Currency) -> CurrencyInfo? {
        return currencyInfo.first { $0.abbreviation == currency.currency }
    }
    
//    func getGraphSupportedCurrencies() -> [Currency] {
//        return zip(graphSupportedSymbols.indices, graphSupportedSymbols).map { Quote(
//            currency: $1,
//            rate: 0,
//            index: $0
//        ) }
//    }
    
//    func getPopularCurrencies() -> [Currency] {
//        return zip(popularCurrencies.indices, popularCurrencies).map { Quote(
//            currency: $1,
//            rate: 0,
//            index: $0
//        ) }
//    }
    
    func getGraphDefaultCurrencies() -> GraphConverterViewModel {
        let info = fetchCurrency()
        guard let baseCode = graphDefaultCurrencies.first,
            let relativeCode = graphDefaultCurrencies.last,
            let baseInfo = info.first(where: { $0.abbreviation == baseCode }),
            let relativeInfo = info.first(where: { $0.abbreviation == relativeCode })
        else {
            print(#function)
            print(#line)
            fatalError("Unknown default graph currencies")
        }
        let base = ChoiceCurrencyViewModel(currency: baseInfo.abbreviation,
                                           title: baseInfo.title,
                                           isFree: baseInfo.isFree)
        let relative = ChoiceCurrencyViewModel(currency: relativeInfo.abbreviation,
                                               title: relativeInfo.title,
                                               isFree: relativeInfo.isFree)
        return GraphConverterViewModel(base: base, relative: relative)
    }

    func getGraphDefaultCryptocurrencies() -> GraphConverterViewModel {
        let info = fetchCrypto()
        guard let baseCode = graphDefaultCryptocurrencies.first,
            let relativeCode = graphDefaultCryptocurrencies.last,
            let baseInfo = info.first(where: { $0.abbreviation == baseCode }),
            let relativeInfo = info.first(where: { $0.abbreviation == relativeCode })
        else {
            print(#function)
            print(#line)
            fatalError("Unknown default graph currencies")
        }
        let base = ChoiceCurrencyViewModel(currency: baseInfo.abbreviation,
                                           title: baseInfo.title,
                                           isFree: baseInfo.isFree)
        let relative = ChoiceCurrencyViewModel(currency: relativeInfo.abbreviation,
                                               title: relativeInfo.title,
                                               isFree: relativeInfo.isFree)
        return GraphConverterViewModel(base: base, relative: relative)
    }
    
    // MARK: Private Methods
    private func getTitle(for code: String) -> String? {
        return Locale.current.localizedString(forCurrencyCode: code)?.capitalized
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

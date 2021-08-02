//
//  CurrenciesInfoService.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/2/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

//TODO: - Нужно отказаться от файла с валютами, в нем нет необходимости: название валюты можно получить из локали, а код и так есть.

final class CurrenciesInfoService {
    static let shared = CurrenciesInfoService()
    
    private var currencyInfo: [CurrencyInfo]!
    private let graphSupportedSymbols = [
        "CAD", "HKD", "ISK", "PHP", "DKK", "HUF", "CZK", "GBP", "RON",
        "SEK", "IDR", "INR", "BRL", "RUB", "HRK", "JPY", "THB", "CHF",
        "EUR", "MYR", "BGN", "TRY", "CNY", "NOK", "NZD", "ZAR", "USD",
        "MXN", "SGD", "AUD", "ILS", "KRW", "PLN"
    ]
    private let popularCurrencies = ["USD", "EUR", "GBP", "CHF", "JPY", "CNY"]
    private let graphDefaultCurrencies = ["USD", "EUR"]
    
    private init() { }
    
    /// load data from json
    func fetch() -> [CurrencyInfo] {
        let path = Bundle.main.path(forResource: "currenciesNames", ofType: ".json")!
        let fileUrl = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: fileUrl, options: .mappedIfSafe)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: String]

        var result = [CurrencyInfo]()
        json.forEach { code, _ in
            guard let title = getTitle(for: code) else { return }
            let model = CurrencyInfo(abbreviation: code, title: title)
            result.append(model)
        }
        currencyInfo = result
        return currencyInfo
    }
    
    func getInfo(by currency: Currency) -> CurrencyInfo? {
        return currencyInfo.first { $0.abbreviation == currency.currency }
    }
    
    func getGraphSupportedCurrencies() -> [Currency] {
        return graphSupportedSymbols.map { Quote(currency: $0, rate: 0) }
    }
    
    func getPopularCurrencies() -> [Currency] {
        return popularCurrencies.map { Quote(currency: $0, rate: 0) }
    }
    
    func getGraphDefaultCurrencies() -> GraphConverterViewModel {
        let info = currencyInfo == nil ? fetch() : currencyInfo!
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
                                           title: baseInfo.title)
        let relative = ChoiceCurrencyViewModel(currency: relativeInfo.abbreviation,
                                               title: relativeInfo.title)
        return GraphConverterViewModel(base: base, relative: relative)
    }
    
    func getSymbol(forCurrencyCode code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        if locale.displayName(forKey: .currencySymbol, value: code) == code {
            let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: code)
        }
        return locale.displayName(forKey: .currencySymbol, value: code)
    }
    
    // MARK: Private Methods
    private func getTitle(for code: String) -> String? {
        return Locale.current.localizedString(forCurrencyCode: code)?.capitalized
    }
}

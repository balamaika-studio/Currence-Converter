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
    private let graphSupportedSymbols = [
        "CAD", "HKD", "ISK", "PHP", "DKK", "HUF", "CZK", "GBP", "RON",
        "SEK", "IDR", "INR", "BRL", "RUB", "HRK", "JPY", "THB", "CHF",
        "EUR", "MYR", "BGN", "TRY", "CNY", "NOK", "NZD", "ZAR", "USD",
        "MXN", "SGD", "AUD", "ILS", "KRW", "PLN"
    ]
    
    private init() { }
    
    /// load data from json
    func fetch() -> [CurrencyInfo] {
        let path = Bundle.main.path(forResource: "currenciesNames", ofType: ".json")!
        let fileUrl = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: fileUrl, options: .mappedIfSafe)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: String]

        currencyInfo = json.map { CurrencyInfo(abbreviation: $0, title: $1) }
        return currencyInfo
    }
    
    func getInfo(by currency: Currency) -> CurrencyInfo? {
        return currencyInfo.first { $0.abbreviation == currency.currency }
    }
    
    func getGraphSupportedCurrencies() -> [Currency] {
        return graphSupportedSymbols.map { Quote(currency: $0, rate: 0) }
    }
}

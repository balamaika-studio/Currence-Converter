//
//  ExchangeRatesHistoryResponse.swift
//  Currency Converter
//
//  Created by Александр Томашевский on 04.06.2021.
//  Copyright © 2021 Kiryl Klimiankou. All rights reserved.
//

import Foundation

struct ExchangeRatesHistoryResponse: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case date, base, rates
    }
    
    let base: String
    private let date: String
    private let rates: [String: Double]
    
    var quotes: [Quote] { rates.map { Quote(currency: $0, rate: $1) } }
    
    var updated: Int {
        guard let date = DateFormatter.exchangeRateGeneralDateFormatter.date(from: self.date) else { return 0 }
        return Int(date.timeIntervalSince1970)
    }
}

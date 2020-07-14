//
//  ExchangeRatesResponse.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/24/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

struct ExchangeRatesResponse: Decodable {
    let base: String
    private let rates: [String: [String: Double]]
    
    var quotes: [TimeFrameQuote] {
        return rates.flatMap { date, quote -> [TimeFrameQuote] in
            return quote.compactMap { currency, rate -> TimeFrameQuote in
                return TimeFrameQuote(currency: currency, rate: rate, date: date)
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case rates = "rates"
        case base
    }
}

protocol Dateble {
    var date: String { get set }
}

struct TimeFrameQuote: Currency, Dateble {
    var currency: String
    var rate: Double
    var date: String
}

extension TimeFrameQuote: Comparable {
    static func < (lhs: TimeFrameQuote, rhs: TimeFrameQuote) -> Bool {
        return lhs.date < rhs.date
    }
    
    static func > (lhs: TimeFrameQuote, rhs: TimeFrameQuote) -> Bool {
        return lhs.date > rhs.date
    }
}

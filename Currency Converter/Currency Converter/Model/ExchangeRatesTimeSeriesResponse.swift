//
//  ExchangeRatesTimeSeriesResponse.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/24/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

struct ExchangeRatesTimeSeriesResponse: Codable {
    let status: Bool?
    let code: Int?
    let msg: String?
    let response: [String: Response]?
    let info: InfoExchangeRates?

    var quotes: [TimeFrameQuote] {
        return response?.compactMap { date, quote -> TimeFrameQuote in
            let rate = Double(quote.c ?? "0") ?? 0
            return TimeFrameQuote(currency: info?.symbol ?? "", rate: rate, date: date, index: 0)
        } ?? []
    }
}

// MARK: - Response
struct Response: Codable {
    let o, h, l, c: String?
    let v: String?
    let t: Int?
    let tm: String?
}

struct InfoExchangeRates: Codable {
    let id, decimal, symbol, period: String?
    let serverTime: String?
    let creditCount: Int?

    enum CodingKeys: String, CodingKey {
        case id, decimal, symbol, period
        case serverTime = "server_time"
        case creditCount = "credit_count"
    }
}

//struct ExchangeRatesTimeSeriesResponse: Decodable {
//    let base: String
//    private let rates: [String: [String: Double]]
//
//    var quotes: [TimeFrameQuote] {
//        return rates.flatMap { date, quote -> [TimeFrameQuote] in
//            return quote.compactMap { currency, rate -> TimeFrameQuote in
//                return TimeFrameQuote(currency: currency, rate: rate, date: date, index: 0)
//            }
//        }
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case rates = "rates"
//        case base
//    }
//}

protocol Dateble {
    var date: String { get set }
}

struct TimeFrameQuote: Currency, Dateble {
    var currency: String
    var rate: Double
    var date: String
    var index: Int
}

extension TimeFrameQuote: Comparable {
    static func < (lhs: TimeFrameQuote, rhs: TimeFrameQuote) -> Bool {
        return lhs.date < rhs.date
    }
    
    static func > (lhs: TimeFrameQuote, rhs: TimeFrameQuote) -> Bool {
        return lhs.date > rhs.date
    }
}

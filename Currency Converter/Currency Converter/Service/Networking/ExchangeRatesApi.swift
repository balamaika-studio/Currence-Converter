//
//  ExchangeRatesApi.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/24/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let exchangeRateGeneralDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        return df
    }()
}

enum ExchangeRatesApi {
    case timeFrame(base: String, currencies: [String], start: String, end: String)
    case live(base: String, type: ExchangeType)
    case historical(date: Date)
    case lastCandleForex(symbols: [String], period: PeriodType)
    case lastCandleCrypto(symbols: [String], period: PeriodType)
}

enum ExchangeType: String {
    case forex = "forex"
    case crypto = "crypto"
}

enum PeriodType: String {
    case oneHour = "1h"
    case oneDay = "1d"
    case oneWeek = "1w"
}

extension ExchangeRatesApi: EndPointType {

    var apiKey: String { "dgBArJjhnOMS5yt88X2TSJwSW" }
    
    var basePath: String {
        return "https://fcsapi.com/api-v3/"
    }
    
    var baseURL: URL {
        guard let url = URL(string: basePath) else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .timeFrame: return "timeseries"
        case .historical(let date): return DateFormatter.exchangeRateGeneralDateFormatter.string(from: date)
        case .live: return "forex/base_latest"
        case .lastCandleForex: return "forex/candle"
        case .lastCandleCrypto: return "crypto/candle"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .timeFrame(let base, let currencies, let start, let end):
            let currenciesString = currencies.joined(separator: ",")
            return .requestWithParameters(bodyParameters: nil,
                                          bodyEncoding: .urlEncoding,
                                          urlParameters: ["base": base,
                                                          "symbols": currenciesString,
                                                          "start_date": start,
                                                          "end_date": end])
        case .live(let base, let type):
            return .requestWithParameters(bodyParameters: nil,
                                          bodyEncoding: .urlEncoding,
                                          urlParameters: ["symbol": base,
                                                          "type": type,
                                                          "access_key": apiKey])
        case .historical: return .request
        case .lastCandleForex(let symbols, let period):
            let currenciesString = symbols.joined(separator: ",")
            return .requestWithParameters(bodyParameters: nil,
                                          bodyEncoding: .urlEncoding,
                                          urlParameters: ["symbol": currenciesString,
                                                          "period": period.rawValue,
                                                          "access_key": apiKey])
        case .lastCandleCrypto(let symbols, let period):
            let currenciesString = symbols.joined(separator: ",")
            return .requestWithParameters(bodyParameters: nil,
                                          bodyEncoding: .urlEncoding,
                                          urlParameters: ["symbol": currenciesString,
                                                          "period": period.rawValue,
                                                          "access_key": apiKey])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}

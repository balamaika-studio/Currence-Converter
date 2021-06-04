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
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
}

enum ExchangeRatesApi {
    case timeFrame(base: String, currencies: [String], start: String, end: String)
    case live(base: String)
    case historical(date: Date)
}

extension ExchangeRatesApi: EndPointType {
    
    var basePath: String {
        return "https://api.exchangerate.host/"
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
        case .live: return "latest"
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
        case .live(let base):
            return .requestWithParameters(bodyParameters: nil,
                                          bodyEncoding: .urlEncoding,
                                          urlParameters: ["base" : base])
        case .historical: return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}

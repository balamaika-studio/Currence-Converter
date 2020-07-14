//
//  ExchangeRatesApi.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/24/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation


enum ExchangeRatesApi {
    case timeFrame(base: String, currencies: [String], start: String, end: String)
}

extension ExchangeRatesApi: EndPointType {
    var basePath: String {
        return "https://api.exchangeratesapi.io/"
    }
    
    var baseURL: URL {
        guard let url = URL(string: basePath) else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .timeFrame: return "history"
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
                                                          "start_at": start,
                                                          "end_at": end])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}

//
//  LiveCurrencyEndPoint.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/26/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation


enum CurrencyLayerApi {
    case live(source: String)
    case historical(date: String)
    case timeFrame(source: String, currencies: [String], start: String, end: String)
}

extension CurrencyLayerApi: EndPointType {
    var basePath: String {
        return "https://api.currencylayer.com/"
    }
    
    var baseURL: URL {
        guard let url = URL(string: basePath) else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .live: return "live"
        case .historical: return "historical"
        case .timeFrame: return "timeframe"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .live(let source):
            return .requestWithParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["source": source,
                                                      "access_key": NetworkManager.movieAPIKey])
        
        case .historical(let date):
            return .requestWithParameters(bodyParameters: nil,
                                          bodyEncoding: .urlEncoding,
                                          urlParameters: ["date": date,
                                                          "access_key": NetworkManager.movieAPIKey])
            
        case .timeFrame(let source, let currencies, let start, let end):
            let currenciesString = currencies.joined(separator: ",")
            return .requestWithParameters(bodyParameters: nil,
                                          bodyEncoding: .urlEncoding,
                                          urlParameters: ["source": source,
                                                          "currencies": currenciesString,
                                                          "start_date": start,
                                                          "end_date": end,
                                                          "access_key": NetworkManager.movieAPIKey])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}

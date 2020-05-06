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
                                                      "access_key": NetworkManager.currencyAPIKey])
        
        case .historical(let date):
            return .requestWithParameters(bodyParameters: nil,
                                          bodyEncoding: .urlEncoding,
                                          urlParameters: ["date": date,
                                                          "access_key": NetworkManager.currencyAPIKey])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}

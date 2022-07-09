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
        case info, response
    }

    private let info: infoModel
    private let response: [String: String]
    
    var quotes: [Quote] { response.map { Quote(currency: $0, rate: Double($1) ?? 0) } }
    
    var updated: Int {
        guard let date = DateFormatter.exchangeRateGeneralDateFormatter.date(from: self.info.server_time) else { return 0 }
        return Int(date.timeIntervalSince1970)
    }
}

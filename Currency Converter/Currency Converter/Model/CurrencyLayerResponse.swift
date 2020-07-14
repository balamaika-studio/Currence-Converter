//
//  CurrencyLayerResponse.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/24/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

struct CurrencyLayerResponse: Decodable {
    let updated: Int
    let base: String
    private let rates: [String: Double]
    
    var quotes: [Quote] {
        return rates.map { name, rate in
            let startIndex = name.index(name.startIndex, offsetBy: base.count)
            let currency = String(name.suffix(from: startIndex))
            
            return Quote(currency: currency, rate: rate)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case updated = "timestamp"
        case base = "source"
        case rates = "quotes"
    }
}

//
//  PairsModel.swift
//  Currency Converter
//
//  Created by Vlad Sys on 24.05.23.
//  Copyright © 2023 Kiryl Klimiankou. All rights reserved.
//

import Foundation

public struct PairsModelSaved {
     var id = UUID().uuidString
     var currencyPairId: String?
     var base: String?
     var relative: String?
     var type: ExchangeType?
}

struct PairsModel: Codable {
    let id, name, decimal, symbol: String
}

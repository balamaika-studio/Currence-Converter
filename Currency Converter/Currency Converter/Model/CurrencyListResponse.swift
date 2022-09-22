//
//  CurrencyListResponse.swift
//  Currency Converter
//
//  Created by Vlad Sys on 10.09.22.
//  Copyright © 2022 Kiryl Klimiankou. All rights reserved.
//

import Foundation

struct CurrencyListResponse: Codable {
    let status: Bool?
    let code: Int?
    let msg: String?
    let response: [CurrencyResponse]?
    let info: Info?
}

// MARK: - Response
struct CurrencyResponse: Codable {
    let id, name, decimal, symbol: String?
}

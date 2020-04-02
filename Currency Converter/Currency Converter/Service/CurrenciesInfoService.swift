//
//  CurrenciesInfoService.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/2/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

class CurrenciesInfoService {
    static let shared = CurrenciesInfoService()
    
    private init() { }
    
    /// load data from json
    func fetch() -> [CurrencyInfo] {
        let path = Bundle.main.path(forResource: "currenciesNames", ofType: ".json")!
        let fileUrl = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: fileUrl, options: .mappedIfSafe)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: String]

        return json.map { CurrencyInfo(abbreviation: $0, title: $1) }
    }
}

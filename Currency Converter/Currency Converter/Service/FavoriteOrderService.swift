//
//  FavoriteOrderService.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 5/23/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

protocol FavoriteOrder {
    func saveOrder(_ currencies: [Currency])
    func fetchOrder() -> [Currency]
}

class FavoriteOrderService: FavoriteOrder {
    private let key = "orderedCodes"
    private var defaults: UserDefaults
    
    static var shared = FavoriteOrderService()
    
    private init() {
        defaults = UserDefaults.standard
    }
    
    func saveOrder(_ currencies: [Currency]) {
        let codes = currencies.map { $0.currency }
        defaults.set(codes, forKey: key)
    }
    
    func fetchOrder() -> [Currency] {
        guard let codes = defaults.stringArray(forKey: key) else {
            return [Currency]()
        }
        return codes.map { Quote(currency: $0, rate: 0) }
    }
    
}

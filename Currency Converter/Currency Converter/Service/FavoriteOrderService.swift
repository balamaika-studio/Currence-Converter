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
    func removeFromOrder(_ currency: Currency)
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
    
    func removeFromOrder(_ currency: Currency) {
        var currencies = fetchOrder()
        currencies.removeAll { $0.currency == currency.currency }
        defaults.removeObject(forKey: key)
        saveOrder(currencies)
    }
    
    func fetchOrder() -> [Currency] {
        guard let codes = defaults.stringArray(forKey: key) else {
            return [Currency]()
        }
        return zip(codes.indices, codes).map { Quote(
            currency: $1,
            rate: 0,
            index: $0
        ) }
    }
}

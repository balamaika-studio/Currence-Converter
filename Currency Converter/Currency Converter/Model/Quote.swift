//
//  Currency.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/19/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

protocol Currency {
    var currency: String { get }
    var rate: Double { get }
    var currencyName: String? { get }
}

//protocol <#name#> {
//    <#requirements#>
//}

extension Currency {
    
    var currencyName: String? {
        Locale.current.localizedString(forCurrencyCode: currency)
    }
}

struct Quote: Currency {
    
    var currency: String
    var rate: Double
    
    init(currency: String, rate: Double) {
        self.currency = currency
        self.rate = rate
    }
}

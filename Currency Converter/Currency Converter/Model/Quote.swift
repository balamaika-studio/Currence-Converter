//
//  Currency.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/19/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

protocol Currency {
    var currency: String { get set }
    var rate: Double { get set }
    var index: Int { get set }
}

struct Quote: Currency {
    var currency: String
    var rate: Double
    var index: Int
}

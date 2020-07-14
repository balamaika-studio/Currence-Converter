//
//  CurrencyPairViewModel.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/14/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

protocol CurrencyPairViewModel {
    var realmId: String { get set }
    var relation: String { get set }
    var change: Change { get set }
    var rate: String { get set }
    var isSelected: Bool { get set }
}

enum Change: String, RawRepresentable {
    case increase
    case drop
    case stay
}

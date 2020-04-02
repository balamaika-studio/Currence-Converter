//
//  RealmCurrency.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/2/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation
import RealmSwift

/*
 Dummy protocol for Entities
 */
public protocol Storable {
}
extension Object: Storable {
}

@objcMembers
public class RealmCurrency: Object, Currency {
    dynamic var currency: String = ""
    dynamic var rate: Double = 0.0
    dynamic var isFavorite: Bool = false
    
    override public static func primaryKey() -> String? {
        return "currency"
    }
}

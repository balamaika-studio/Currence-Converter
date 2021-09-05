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
public protocol Storable: Object {
}

@objcMembers
public class RealmCurrency: Object, Currency {
    @Persisted var currency: String
    @Persisted var rate: Double
    @Persisted var isFavorite: Bool = false
    
    public override class func primaryKey() -> String? {
        return "currency"
    }
}

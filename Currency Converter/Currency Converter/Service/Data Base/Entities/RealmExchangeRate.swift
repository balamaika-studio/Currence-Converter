//
//  RealmExchangeRate.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/9/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
public class RealmExchangeRate: Object {
    dynamic var id: String = UUID().uuidString
    dynamic var base: RealmCurrency? = nil
    dynamic var relative: RealmCurrency? = nil
    dynamic var isSelected: Bool = false
    
    public override class func primaryKey() -> String? {
        return "id"
    }
}

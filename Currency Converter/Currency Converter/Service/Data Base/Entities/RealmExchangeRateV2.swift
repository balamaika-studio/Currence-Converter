//
//  RealmExchangeRateV2.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/9/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
public class RealmExchangeRateV2: Object {
    dynamic var id: String = UUID().uuidString
    dynamic var base: RealmCurrencyV2? = nil
    dynamic var relative: RealmCurrencyV2? = nil
    dynamic var isSelected: Bool = false
    
    public override class func primaryKey() -> String? {
        return "id"
    }
}

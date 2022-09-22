//
//  RealmPairCurrency.swift
//  Currency Converter
//
//  Created by Vlad Sys on 10.09.22.
//  Copyright © 2022 Kiryl Klimiankou. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
public class RealmPairCurrency: Object {

    dynamic var id = UUID().uuidString
    dynamic var currencyPairId: String?
    dynamic var base: String?
    dynamic var relative: String?
    dynamic var type: ExchangeType?

    public override class func primaryKey() -> String? {
        return "id"
    }
}


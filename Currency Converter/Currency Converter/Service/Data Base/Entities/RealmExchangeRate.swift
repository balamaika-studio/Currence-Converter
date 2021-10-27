//
//  RealmExchangeRate.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/9/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation
//import RealmSwift
//
//@objcMembers
//public class RealmExchangeRate: Object {
//    dynamic var id: String = UUID().uuidString
//    dynamic var base: Currency? = nil
//    dynamic var relative: Currency? = nil
//    dynamic var isSelected: Bool = false
//    
//    public override class func primaryKey() -> String? {
//        return "id"
//    }
//}

struct RealmExchangeRate: RawRepresentable {
    
    enum Error: Swift.Error {
        case stringPairParsingFailed(String)
    }
    
    private static let currencies = JSONDataStoreManager.default(for: ExchangeRatesHistoryResponse.self).state?.quotes ?? []
    private static let selected = UserDefaults.standard.selectedExchangePairs
    
    let id: String = UUID().uuidString
    var base: Currency
    var relative: Currency
    var isSelected = false
    
    var rawValue: String { "\(base.currency)/\(relative.currency)" }
    
    init?(rawValue: String) {
        try? self.init(stringCurrencyPair: rawValue)
    }
    
    init(stringCurrencyPair: String) throws {
        let ar = stringCurrencyPair.split(separator: "/")
        guard
            let firstCode = ar.first,
            !firstCode.isEmpty,
            let secondCode = ar.last,
            !secondCode.isEmpty,
            let firstCur = Self.currencies.first(where: { $0.currency == firstCode }),
            let secondCur = Self.currencies.first(where: { $0.currency == secondCode })
        else { throw Error.stringPairParsingFailed(stringCurrencyPair) }
        self.init(base: firstCur, relative: secondCur)
        self.isSelected = Self.selected.contains(stringCurrencyPair)
    }
    
    init(base: Currency, relative: Currency) {
        self.base = base
        self.relative = relative
    }
    
    static func all() -> [RealmExchangeRate] {
        let pairs = UserDefaults.standard.exchangePairs
        return pairs.compactMap { RealmExchangeRate(rawValue: $0) }
    }
}

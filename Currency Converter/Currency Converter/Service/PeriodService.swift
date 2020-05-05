//
//  PeriodService.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/17/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

class PeriodService {
    private typealias periodTuple = (key: String, value: Int)
    
    private let normalKeyLength = 6
    private let periods: [Period] = [.week, .halfMonth, .month,
                                     .threeMonths, .halfYear, .nineMonths,
                                     .year]
    
    static let shared = PeriodService()
    
    private init() { }
    
    func buildGraphPeriodModels() -> [GraphPeriod] {
        return periods
            .map(normalizeKeyLength)
            .map { GraphPeriod(interval: $0.value, title: $0.key) }
    }
    
    private func normalizeKeyLength(_ peiod: Period) -> periodTuple {
        var normalizedkey = peiod.description
        if peiod.description.count < normalKeyLength {
            guard let spaceIndex = normalizedkey.firstIndex(of: " ") else {
                fatalError("Can't find space in period data.")
            }
            let spaces = String(repeating: " ",
                                count: normalKeyLength - peiod.description.count)
            normalizedkey.insert(Character(spaces), at: spaceIndex)
        }
        return (key: normalizedkey, value: peiod.rawValue)
    }
}

enum Period: Int {
    case week = 432000
    case halfMonth = 1296000
    case month = 2592000
    case threeMonths = 7889231
    case halfYear = 15778462
    case nineMonths = 23667694
    case year = 31556925
}

extension Period: CustomStringConvertible {
    var description: String {
        var result: String
        switch self {
        case .week: result = "5 дней"
        case .halfMonth: result = "15 дней"
        case .month: result = "1 мес"
        case .threeMonths: result = "3 мес"
        case .halfYear: result = "6 мес"
        case .nineMonths: result = "9 мес"
        case .year: result = "1 год"
        }
        return result
    }
}

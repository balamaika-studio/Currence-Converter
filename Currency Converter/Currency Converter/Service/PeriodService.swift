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
    private let periods = [
        "5 дней": 432000,
        "15 дней": 1296000,
        "1 мес": 2592000,
        "3 мес": 7889231,
        "6 мес": 15778462,
        "9 мес": 23667694,
        "1 год": 31556925
    ]
    
    static let shared = PeriodService()
    
    private init() { }
    
    func buildGraphPeriodModels() -> [GraphPeriod] {
        return periods
            .sorted { $0.value < $1.value }
            .map(normalizeKeyLength)
            .map { GraphPeriod(interval: $0.value, title: $0.key) }
    }
    
    private func normalizeKeyLength(_ data: periodTuple) -> periodTuple {
        var normalizedkey = data.key
        if data.key.count < normalKeyLength {
            guard let spaceIndex = normalizedkey.firstIndex(of: " ") else {
                fatalError("Can't find space in period data.")
            }
            let spaces = String(repeating: " ", count: normalKeyLength - data.key.count)
            normalizedkey.insert(Character(spaces), at: spaceIndex)
        }
        return (key: normalizedkey, value: data.value)
    }
}

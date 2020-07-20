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
        return periods.map { period in
            let periodData = period.description.split(separator: " ").compactMap { String($0) }
            let numberPeriod = periodData.first!
            let title = periodData.last!
            return GraphPeriod(interval: period.rawValue, period: numberPeriod, title: title)
        }
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
    
    func range(to: Self) -> ClosedRange<Int> {
        return self.rawValue...to.rawValue
    }
    
    var availableDayCount: Int {
        var result: Int
        switch self {
        case .week: result = 5
        case .halfMonth: result = 15
        case .month: result = 30
        case .threeMonths: result = 90
        case .halfYear: result = 180
        case .nineMonths: result = 270
        case .year: result = 360
        }
        return result
    }
}

extension Period: CustomStringConvertible {
    var description: String {
        var result: String
        switch self {
        case .week: result = "5 \(R.string.localizable.days())"
        case .halfMonth: result = "15 \(R.string.localizable.days())"
        case .month: result = "1 \(R.string.localizable.months())"
        case .threeMonths: result = "3 \(R.string.localizable.months())"
        case .halfYear: result = "6 \(R.string.localizable.months())"
        case .nineMonths: result = "9 \(R.string.localizable.months())"
        case .year: result = "1 \(R.string.localizable.year())"
        }
        return result
    }
}

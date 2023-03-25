//
//  ChartXValueFormatter.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 5/6/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit
import Charts

class ChartXValueFormatter: AxisValueFormatter {
    private var dates: [String]
    private var previousDate: String
    
    init(dates: [String]) {
        self.dates = dates
        previousDate = String()
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        var result = String()
        let value = Int(value)
        guard value >= 0, value < dates.count else { return result }
        let currentDate = dates[value]
        
        if previousDate != currentDate {
            result = currentDate
            previousDate = currentDate
        }
        return result
    }
}

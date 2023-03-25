//
//  ChartYValueFormatter.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 7/7/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit
import Charts

class ChartYValueFormatter: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return AccuracyManager.shared.formatNumber(value)
    }
}

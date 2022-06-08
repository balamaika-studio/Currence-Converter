//
//  DateExtension.swift
//  Currency Converter
//
//  Created by Vlad Sys on 8.06.22.
//  Copyright © 2022 Kiryl Klimiankou. All rights reserved.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d.MM.YYYY, hh:mm"
        let currentTime = dateFormatter.string(from: self)
        return currentTime
    }
}

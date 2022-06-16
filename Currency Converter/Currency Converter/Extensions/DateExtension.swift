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
        if Locale.current.identifier.starts(with: "ru") {
            dateFormatter.dateFormat = "d.MM.YYYY, HH:mm"
        } else {
            dateFormatter.dateFormat = "d.MM.YYYY, hh:mm a"
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
        }
        let currentTime = dateFormatter.string(from: self)
        return currentTime
    }
}

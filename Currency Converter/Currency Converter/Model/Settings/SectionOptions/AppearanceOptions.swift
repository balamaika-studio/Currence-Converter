//
//  AppearanceOptions.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/20/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

enum AppearanceOptions: Int, CaseIterable {
    case accuracy
    case clearField
    case theme
}
extension AppearanceOptions: SectionCellType {
    var detailText: String {
        switch self {
        case .accuracy: return "2 \(R.string.localizable.decimalPlaces())"
        case .clearField: return R.string.localizable.enabled().uppercased()
        case .theme: return R.string.localizable.disabled().uppercased()
        }
    }
    
    var containsSwitch: Bool {
        switch self {
        case .accuracy: return false
        case .clearField: return true
        case .theme: return true
        }
    }
    
    var description: String {
        switch self {
        case .accuracy: return R.string.localizable.accuracyTitle()
        case .clearField: return R.string.localizable.clearAmount()
        case .theme: return R.string.localizable.theme()
        }
    }
}

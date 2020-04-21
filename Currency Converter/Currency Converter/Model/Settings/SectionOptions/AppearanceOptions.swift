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
        case .accuracy: return "2 десятичных знака"
        case .clearField: return "Включено"
        case .theme: return "Светлая"
        }
    }
    
    var containsSwitch: Bool {
        switch self {
        case .accuracy: return false
        case .clearField: return true
        case .theme: return false
        }
    }
    
    var description: String {
        switch self {
        case .accuracy: return "Десятичные знаки"
        case .clearField: return "Очищать сумму при наборе"
        case .theme: return "Тема"
        }
    }
}

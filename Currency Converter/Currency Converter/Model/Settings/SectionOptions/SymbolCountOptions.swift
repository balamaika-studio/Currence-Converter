//
//  SymbolCountOptions.swift
//  Currency Converter
//
//  Created by Vlad Sys on 23.04.23.
//  Copyright © 2023 Kiryl Klimiankou. All rights reserved.
//

enum SymbolCountOptions: Int, CaseIterable {
    case accuracy
}
extension SymbolCountOptions: SectionCellType {
    var detailText: String {
        switch self {
        case .accuracy: return "2 \(R.string.localizable.decimalPlaces())"
        }
    }
    
    var containsSwitch: Bool {
        switch self {
        case .accuracy: return false
        }
    }
    
    var description: String {
        switch self {
        case .accuracy: return R.string.localizable.accuracyTitle()
        }
    }
}

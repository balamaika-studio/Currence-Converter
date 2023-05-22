//
//  SettingsSection.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/20/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

enum SettingsSection: Int, CaseIterable {
    case purchases
    case network
    case symbolCount
    case appearance
}

extension SettingsSection: CustomStringConvertible {
    var description: String {
        switch self {
        case .network: return R.string.localizable.networkSectionTitle()
        case .appearance: return R.string.localizable.appearanceSectionTitle()
        case .purchases: return String()
        case .symbolCount: return R.string.localizable.symbolCountSectionTitle()
        }
    }
}

enum SettingsPosition {
    case first
    case middle
    case last
    case all
}

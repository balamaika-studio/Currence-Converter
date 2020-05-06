//
//  SettingsSection.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/20/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

enum SettingsSection: Int, CaseIterable {
    case network
    case appearance
}

extension SettingsSection: CustomStringConvertible {
    var description: String {
        switch self {
        case .network: return R.string.localizable.networkSectionTitle()
        case .appearance: return R.string.localizable.appearanceSectionTitle()
        }
    }
}

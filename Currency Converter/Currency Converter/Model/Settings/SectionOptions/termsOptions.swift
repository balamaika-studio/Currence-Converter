//
//  termsOptions.swift
//  Currency Converter
//
//  Created by Vlad Sys on 26.10.23.
//  Copyright © 2023 Kiryl Klimiankou. All rights reserved.
//

import Foundation

enum termsOptions: Int, CaseIterable {
    case terms
    case policy
}
extension termsOptions: SectionCellType {
    var detailText: String {
        switch self {
        case .terms: return R.string.localizable.enabled().uppercased()
        case .policy: return R.string.localizable.disabled().uppercased()
        }
    }
    
    var containsSwitch: Bool {
        switch self {
        case .terms: return false
        case .policy: return false
        }
    }
    
    var description: String {
        switch self {
        case .terms: return R.string.localizable.terms()
        case .policy: return R.string.localizable.policy()
        }
    }
}

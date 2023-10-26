//
//  RateOptions.swift
//  Currency Converter
//
//  Created by Vlad Sys on 26.10.23.
//  Copyright © 2023 Kiryl Klimiankou. All rights reserved.
//

import Foundation

enum RateOptions: Int, CaseIterable {
    case feedback
    case rate
}
extension RateOptions: SectionCellType {
    var detailText: String {
        switch self {
        case .feedback: return R.string.localizable.feedbackAndSupport()
        case .rate: return R.string.localizable.rateInAppStore()
        }
    }
    
    var containsSwitch: Bool {
        switch self {
        case .feedback: return false
        case .rate: return false
        }
    }
    
    var description: String {
        switch self {
        case .feedback: return R.string.localizable.feedbackAndSupport()
        case .rate: return R.string.localizable.rateInAppStore()
        }
    }
}

//
//  SwitchState.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/23/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

enum SwitchState {
    case on
    case off
}

extension SwitchState: RawRepresentable {
    typealias RawValue = Bool
    
    var rawValue: RawValue {
        switch self {
        case .on: return true
        case .off: return false
        }
    }
    
    init?(rawValue: RawValue) {
        self = rawValue == true ? .on : .off
    }
}

extension SwitchState: CustomStringConvertible {
    var description: String {
        switch self {
        case .on: return R.string.localizable.enabled()
        case .off: return R.string.localizable.disabled()
        }
    }
}

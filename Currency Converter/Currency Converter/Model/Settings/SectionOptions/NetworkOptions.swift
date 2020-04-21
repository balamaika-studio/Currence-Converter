//
//  NetworkOptions.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/20/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

enum NetworkOptions: Int, CaseIterable {
    case autoUpdate
}

extension NetworkOptions: SectionCellType {
    var detailText: String {
        switch self {
        case .autoUpdate: return "Автоматическое обновление включено"
        }
    }
    
    var containsSwitch: Bool {
        switch self {
        case .autoUpdate: return true
        }
    }
    
    var description: String {
        switch self {
        case .autoUpdate: return "Автоматическое обновление"
        }
    }
}

//
//  SectionType.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/20/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

protocol SectionCellType: CustomStringConvertible {
    var containsSwitch: Bool { get }
    var detailText: String { get }
}

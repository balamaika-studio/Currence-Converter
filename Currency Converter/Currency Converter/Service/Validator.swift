//
//  Validator.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 7/8/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

final class Validator {
    /// valid formats: [1000.0, 001, .001]
    static func isConverterFieldCorrect(text: String) -> Bool {
        if text.isEmpty || text == "," { return true }
        let regEx = "^\\d*\\.?\\d+$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regEx)
        return predicate.evaluate(with: text)
    }
}

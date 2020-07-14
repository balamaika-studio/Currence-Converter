//
//  Weak.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/23/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

/// A box that allows us to weakly hold on to an object
struct Weak<Object: AnyObject> {
    weak var value: Object?
}

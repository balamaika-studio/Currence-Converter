//
//  ArrayExtension.swift
//  Currency Converter
//
//  Created by Vlad Sys on 29.07.22.
//  Copyright © 2022 Kiryl Klimiankou. All rights reserved.
//

import Foundation


extension Array {
    public mutating func appendDistinct<S>(contentsOf newElements: S, where condition:@escaping (Element, Element) -> Bool) where S : Sequence, Element == S.Element {
        newElements.forEach { (item) in
            if !(self.contains(where: { (selfItem) -> Bool in
                return !condition(selfItem, item)
            })) {
                self.append(item)
            }
        }
    }
}

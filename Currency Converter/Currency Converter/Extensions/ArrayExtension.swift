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

extension Array where Element: Equatable {

    func reorder(by preferredOrder: [Element]) -> [Element] {

        return self.sorted { (a, b) -> Bool in
            guard let first = preferredOrder.firstIndex(of: a) else {
                return false
            }

            guard let second = preferredOrder.firstIndex(of: b) else {
                return true
            }

            return first < second
        }
    }
}

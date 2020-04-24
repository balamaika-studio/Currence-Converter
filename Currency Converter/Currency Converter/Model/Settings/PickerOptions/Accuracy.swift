//
//  Accuracy.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/24/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

enum Accuracy: Int, CaseIterable, Codable {
    static var defaultAccurancy: Accuracy {
        return .two
    }
    
    case one = 1
    case two
    case three
    case four
    
    static func encode(value: Accuracy) -> Data? {
        guard let data = try? JSONEncoder().encode(value) else {
            return nil
        }
        return data
    }
    
    static func decode(data: Data) -> Accuracy? {
        guard let accuracy = try? JSONDecoder().decode(Accuracy.self, from: data) else {
            return nil
        }
        return accuracy
    }
}

extension Accuracy: CustomStringConvertible {
    var description: String {
        var result = "\(self.rawValue) "
        switch self {
        case .one: result += "десятичный знак"
        case .two: fallthrough
        case .three: fallthrough
        case .four: result += "десятичных знака"
        }
        return result
    }
}

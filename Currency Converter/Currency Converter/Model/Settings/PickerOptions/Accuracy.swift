//
//  Accuracy.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/24/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

enum Accuracy: Int, CaseIterable {
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
        case .one: result += R.string.localizable.decimalPlace()
        case .two: fallthrough
        case .three: fallthrough
        case .four: result += R.string.localizable.decimalPlaces()
        }
        return result
    }
}

extension Accuracy: Codable {
    enum Key: CodingKey {
        case rawValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 1: self = .one
        case 2: self = .two
        case 3: self = .three
        case 4: self = .four
        default: self = Accuracy.defaultAccurancy
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .one: try container.encode(1, forKey: .rawValue)
        case .two: try container.encode(2, forKey: .rawValue)
        case .three: try container.encode(3, forKey: .rawValue)
        case .four: try container.encode(4, forKey: .rawValue)
        }
    }
}

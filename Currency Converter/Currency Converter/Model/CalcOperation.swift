//
//  CalcOperation.swift
//  Currency Converter
//
//  Created by Александр Томашевский on 09.06.2021.
//  Copyright © 2021 Kiryl Klimiankou. All rights reserved.
//

import Foundation

enum CalcArg {
    case operation(Resultable)
    case number(Decimal)
    
    func getValue() -> Decimal {
        switch self {
        case .number(let number): return number
        case .operation(var op): return op.result
        }
    }
}

enum CalcOperationType: CustomStringConvertible, CaseIterable {
    
    enum Priority: UInt {
        case normal, high
    }
    
    case add, subt, mult, div//, percent
    
    var priority: Priority {
        switch self {
        case .div: return .high
        case .mult: return .high
        default: return .normal
        }
    }
    
    var locale: Locale {
        .current
    }
    
    var sign: String {
        switch self {
        case .add: return "+"
        case .div: return "/"
        case .mult: return "*"
        case .subt: return "-"
        }
    }
    
    var signPattern: String {
        "\\\(sign)"
    }
    
    var decimalSeparator: String {
        locale.decimalSeparator ?? "."
    }
    
    var decimalSeparatorPattern: String {
        "\\\(decimalSeparator)"
    }
    
    var decimalNumberPattern: String {
        "-?\\d+(\(decimalSeparatorPattern)\\d+)?"
    }
    
    var pattern: String {
        switch self {
        default: return "\(decimalNumberPattern)\\s\(signPattern)\\s\(decimalNumberPattern)"
        }
    }
    
    var description: String {
        switch self {
        case .div: return "division"
        case .mult: return "multiplication"
        case .subt: return "subtraction"
        case .add: return "addition"
        }
    }
}

protocol Resultable {
    var result: Decimal { mutating get }
}

struct CalcOperation: Resultable {
    
    enum Error: Swift.Error, LocalizedError {
        
        case stringHasNotEnoughDigits(String)
        case failedParseDigits(String)
        
        var errorDescription: String? {
            switch self {
            case .stringHasNotEnoughDigits(let string):
                return "Received string \"\(string)\" is not having enough number of decimal digits (two)."
            case .failedParseDigits(let string):
                return "Recived string \"\(string)\" is having one or more digits that cant be parsed."
            }
        }
    }
    
    let arg1: CalcArg
    let arg2: CalcArg
    let type: CalcOperationType
    private(set) lazy var result: Decimal = getResult()
    
    init(arg1: CalcArg, arg2: CalcArg, type: CalcOperationType) {
        self.arg1 = arg1
        self.arg2 = arg2
        self.type = type
    }
    
    init(type: CalcOperationType, string: String) throws {
        self.type = type
        let re = try NSRegularExpression(pattern: type.decimalNumberPattern)
        let matches = re.matches(in: string, range: NSRange(location: 0, length: string.count))
        guard matches.count >= 2 else { throw Error.stringHasNotEnoughDigits(string) }
        let formatter = NumberFormatter(calcOperationType: type)
        let str1 = String(string[Range(matches[0].range, in: string)!])
        let str2 = String(string[Range(matches[1].range, in: string)!])
        guard
            let digit1 = formatter.number(from: str1),
            let digit2 = formatter.number(from: str2)
        else { throw Error.failedParseDigits(string) }
        arg1 = .number(digit1.decimalValue)
        arg2 = .number(digit2.decimalValue)
    }
    
    private func getResult() -> Decimal {
        switch type {
        case .add: return arg1.getValue() + arg2.getValue()
        case .div: return arg1.getValue() / arg2.getValue()
        case .mult: return arg1.getValue() * arg2.getValue()
        case .subt: return arg1.getValue() - arg2.getValue()
        }
    }
}

extension NumberFormatter {
    
    convenience init(calcOperationType type: CalcOperationType) {
        self.init()
        allowsFloats = true
        decimalSeparator = type.decimalSeparator
        locale = type.locale
        minusSign = CalcOperationType.subt.sign
        plusSign = CalcOperationType.add.sign
        generatesDecimalNumbers = true
    }
}

//extension CalcOperation: RawRepresentable {
//
//    var rawValue: String {
//
//    }
//
//    convenience init?(rawValue: String) {
//        let
//    }
//}

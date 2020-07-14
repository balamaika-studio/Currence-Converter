//
//  CodableColor.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 5/5/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

/// Allows you to use Swift encoders and decoders to process UIColor
public struct CodableColor {
    /// The color to be (en/de)coded
    let color: UIColor
}

extension CodableColor: Encodable {
    public func encode(to encoder: Encoder) throws {
        let nsCoder = NSKeyedArchiver()
        color.encode(with: nsCoder)
        var container = encoder.unkeyedContainer()
        try container.encode(nsCoder.encodedData)
    }
}

extension CodableColor: Decodable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let decodedData = try container.decode(Data.self)

        var nsCoder: NSKeyedUnarchiver!
        if #available(iOS 13.0, *) {
            nsCoder = try NSKeyedUnarchiver(forReadingFrom: decodedData)
        } else {
            nsCoder = NSKeyedUnarchiver(forReadingWith: decodedData)
        }

        guard let color = UIColor(coder: nsCoder) else {
            fatalError("Decode Color Error")
        }
        self.color = color
    }
}

public extension UIColor {
    func codable() -> CodableColor {
        return CodableColor(color: self)
    }
}

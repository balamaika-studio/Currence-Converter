//
//  NetworkService.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/19/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation
import XMLParsing

protocol CurrencyParsing {
    func parse(data: Data) -> [Currency]
}

protocol CurrencyParserCallback {
    var newCurrency: ((Currency) -> Void)? { get set }
}

class ECBParser: NSObject, XMLParserDelegate, CurrencyParserCallback {
    var newCurrency: ((Currency) -> Void)?

    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        guard
            let currency = attributeDict[Cube.CodingKeys.currency.description],
            let rate = attributeDict[Cube.CodingKeys.rate.description] else {
                return
        }
        let cube = Cube(currency: currency, rate: Double(rate)!)
        newCurrency?(cube)
    }
}

class ParsingService: CurrencyParsing {
    var xmlParser: XMLParser?
    var logic: (CurrencyParserCallback & XMLParserDelegate)!

    init(parseLogic: (CurrencyParserCallback & XMLParserDelegate)) {
        logic = parseLogic
    }

    func parse(data: Data) -> [Currency] {
        var result = [Currency]()
        
        xmlParser = XMLParser(data: data)
        xmlParser?.delegate = logic
        logic.newCurrency = { currency in
            result.append(currency)
        }
        
        xmlParser?.parse()
        return result
    }
}

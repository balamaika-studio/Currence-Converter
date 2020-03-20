//
//  ConverterModels.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/16/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

enum Converter {
    
    enum Model {
        struct Request {
            enum RequestType {
                case changeCurrencyRegarding(currency: Currency)
                case loadConverterCurrencies
            }
        }
        struct Response {
            enum ResponseType {
                case converterCurrencies(first: Currency, second: Currency)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case showConverterViewModel(_ viewModel: ConverterViewModel)
            }
        }
    }
}

protocol ExchangeCurrency {
    var currency: String { get set }
    var regardingRate: String { get set }
}

struct Exchange: ExchangeCurrency {
    var currency: String
    var regardingRate: String
}

struct ConverterViewModel {
    let firstExchange: ExchangeCurrency
    let secondExchange: ExchangeCurrency
}

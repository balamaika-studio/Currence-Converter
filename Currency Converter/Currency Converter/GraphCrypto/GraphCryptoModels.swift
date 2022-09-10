//
//  GraphCryptoModels.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/17/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

enum GraphCrypto {
    
    enum Model {
        struct Request {
            enum RequestType {
                case getGraphCryptoPeriods
                case getDefaultConverter
                case updateConverterCurrency
                case loadGraphCryptoData(base: String, relative: String, period: GraphPeriod)
            }
        }
        struct Response {
            enum ResponseType {
                case GraphCryptoPeriods([GraphPeriod])
                case defaultConverter(GraphConverterViewModel)
                case newConverterCurrency(Currency)
                case GraphCryptoData([TimeFrameQuote], period: GraphPeriod)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case showGraphCryptoPeriods([GraphPeriod])
                case showGraphCryptoConverter(_ viewModel: GraphConverterViewModel)
                case updateConverter(newModel: ChoiceCurrencyViewModel)
                case showGraphCryptoData(_ viewModel: GraphViewModel)
            }
        }
    }
    
}

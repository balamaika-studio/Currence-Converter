//
//  GraphModels.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/17/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

enum Graph {
    
    enum Model {
        struct Request {
            enum RequestType {
                case getGraphPeriods
                case getDefaultConverter
                case updateConverterCurrency
            }
        }
        struct Response {
            enum ResponseType {
                case graphPeriods([GraphPeriod])
                case defaultConverter(GraphConverterViewModel)
                case newConverterCurrency(Currency)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case showGraphPeriods([GraphPeriod])
                case showGraphConverter(_ viewModel: GraphConverterViewModel)
                case updateConverter(newModel: ChoiceCurrencyViewModel)
            }
        }
    }
    
}

/// Interval in seconds
protocol Interval {
    var interval: Int { get }
}

struct GraphPeriod: Interval {
    var interval: Int
    let title: String
}

struct GraphConverterViewModel {
    let base: ChoiceCurrencyViewModel
    let relative: ChoiceCurrencyViewModel
}

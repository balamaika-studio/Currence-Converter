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
                case loadGraphData(base: String, relative: String, period: GraphPeriod)
            }
        }
        struct Response {
            enum ResponseType {
                case graphPeriods([GraphPeriod])
                case defaultConverter(GraphConverterViewModel)
                case newConverterCurrency(Currency)
                case graphData([TimeFrameQuote], period: GraphPeriod)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case showGraphPeriods([GraphPeriod])
                case showGraphConverter(_ viewModel: GraphConverterViewModel)
                case updateConverter(newModel: ChoiceCurrencyViewModel)
                case showGraphData(_ viewModel: GraphViewModel)
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

struct GraphPeriodInterval {
    let startDate: String
    let endDate: String
}

struct GraphViewModel {
    let data: [Double]
    let dates: [String]
}

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
                case changeCurrency(name: String)
                case loadConverterCurrencies
                case loadFavoriteCurrencies
                case updateBaseCurrency(base: Currency)
                case updateCurrencies
                case remove(favorite: FavoriteConverterViewModel)
            }
        }
        struct Response {
            enum ResponseType {
                case converterCurrencies(first: Currency, second: Currency)
                case favoriteCurrencies([Currency])
                case updateBaseCurrency(base: Currency)
                case error(_ message: String?)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case showError(message: String)
                case showConverterViewModel(_ viewModel: ConverterViewModel)
                case showFavoriteViewModel(_ viewModel: [FavoriteConverterViewModel])
            }
        }
    }
}

protocol ExchangeCurrency: Currency {
    var exchangeRate: Double { get set }
    var regardingRate: String { get set }
}

struct Exchange: ExchangeCurrency {
    var currency: String
    var rate: Double
    var exchangeRate: Double
    var regardingRate: String
}

struct ConverterViewModel {
    let firstExchange: ExchangeCurrency
    let secondExchange: ExchangeCurrency
    let updated: String
}


// MARK: - Favorite View Model
struct FavoriteConverterViewModel {
    let currency: String
    let title: String
    let regardingRate: String
}

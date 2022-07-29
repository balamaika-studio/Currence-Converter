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
                case loadCryptoCurrencies
                case loadFavoriteCurrenciesFirst(total: Double? = nil, index: Int = 0)
                case loadFavoriteCurrencies(total: Double? = nil, index: Int = 0)
                case updateBaseCurrency(base: Currency)
                case updateCurrencies
                case updateCrypto
                case remove(favorite: Currency)
                case changeBottomCurrency(with: Currency)
                case saveFavoriteOrder(currencies: [Currency])
            }
        }
        struct Response {
            enum ResponseType {
                case converterCurrencies(first: Currency, second: Currency)
                case favoriteCurrencies([Currency], total: Double, totalIndex: Int)
                case favoriteCurrenciesPartUpdate([Currency], total: Double, totalIndex: Int)
                case updateBaseCurrency(base: Currency)
                case error(_ message: String?)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case showError(message: String)
                case showConverterViewModel(_ viewModel: ConverterViewModel)
                case showFavoriteViewModel(_ viewModel: [FavoriteConverterViewModel])
                case updateFavoriteViewModel(_ viewModel: [FavoriteConverterViewModel], indexPathes: [IndexPath])
            }
        }
    }
}

protocol ExchangeCurrency: Currency {
    var exchangeRate: Double { get set }
    var regardingRate: String { get set }
}

struct Exchange: ExchangeCurrency {
    var index: Int
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
public struct FavoriteConverterViewModel: Currency {
    var currency: String
    let title: String
    let total: String
    var rate: Double
    var isSelected: Bool
    var index: Int

    public mutating func setSelected(_ isSelected: Bool) {
        self.isSelected = isSelected
    }

    public mutating func setIndex(_ index: Int) {
        self.index = index
    }
}

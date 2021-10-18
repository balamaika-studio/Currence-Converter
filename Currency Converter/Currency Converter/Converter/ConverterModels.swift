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
                //case changeCurrency(name: String)
                case loadConverterCurrencies
                case loadFavoriteCurrencies
                //case updateBaseCurrency(base: Currency)
                case updateCurrencies
                case remove(favorite: Currency)
                //case changeBottomCurrency(with: Currency)
                case saveFavoriteOrder(currencies: [Currency])
                case updateBaseCount(currency: Currency, count: Double)
            }
        }
        struct Response {
            enum ResponseType {
                //case converterCurrencies(first: Currency, second: Currency)
                case favoriteCurrencies(DataSource<RealmCurrency>, baseCount: Double)
                //case updateBaseCurrency(base: Currency)
                case error(_ message: String?)
                case updateLocalFavoriteCurrencies(baseCount: Double)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case updateLocalFavoriteCurrencies(baseCount: Double)
                case showError(message: String)
                case showConverterViewModel(_ viewModel: ConverterViewModel)
                case showFavoriteViewModel(_ viewModel: [FavoriteConverterViewModel])
            }
        }
    }
}

enum CurrencyType {
    case general, cript
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

//struct ConverterViewModel {
//    let firstExchange: ExchangeCurrency
//    let secondExchange: ExchangeCurrency
//    let updated: String
//}

//protocol ConverterCellModelProtocol {
//    var value: BehaviorRelay<Double> { get }
//    var image: UIImage { get }
//    var abbriviation: String { get }
//    var fullName: String { get }
//    var symbol: String { get }
//}
//
//struct ConverterCellModel: ConverterCellModelProtocol {
//
//    let value: BehaviorRelay<Double>
//    let image: UIImage
//    let abbriviation: String
//    let fullName: String
//    let symbol: String
//
//    init(value: Double, image: UIImage, fullName: String, abbriviation: String, symbol: String) {
//        self.value = .init(value: value)
//        self.image = image
//        self.abbriviation = abbriviation
//        self.fullName = fullName
//        self.symbol = symbol
//    }
//}

//extension ConverterCellModel {
//
//    init(currency: Currency, baseCurrencyRate: Double, baseCurrencyValue: Double, accuracyManager: AccuracyManager, infoService: CurrenciesInfoService) {
//        let rate = currency.rate / baseCurrencyRate
//        let totalSum = rate * baseCurrencyValue
//        let roundedSum = accuracyManager.formatNumber(totalSum)
//        let symbol = infoService.getSymbol(forCurrencyCode: currency.currency) ?? ""
//        let stringSum = "\(roundedSum) \(symbol)"
//        guard let title = CurrenciesInfoService.shared.getInfo(by: currency)?.title else { return }
//        self.init(value: <#T##Double#>, image: <#T##UIImage#>, fullName: <#T##String#>, abbriviation: <#T##String#>, symbol: <#T##String#>)
//    }
//}

protocol ConverterCellModelProtocol: Equatable {
    var currencyName: String { get }
    var currencyCode: String { get }
    var formattedCount: String { get }
}

struct ConverterCellModel: ConverterCellModelProtocol {
    
    let currencyName: String
    let currencyCode: String
    let formattedCount: String
    
    init(item: ConverterServiceItemType) {
        currencyName = item.currency.currencyName
        currencyCode = item.currency.currency
        formattedCount = AccuracyManager.shared.formatNumber(item.count)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.currencyCode == rhs.currencyCode
    }
}

//struct FavoriteConverterViewModel: Currency {
//    let currency: String
//    let title: String
//    let count: String
//    var baseCount: Double
//}

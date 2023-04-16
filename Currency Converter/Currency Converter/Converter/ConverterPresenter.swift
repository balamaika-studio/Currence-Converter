//
//  ConverterPresenter.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/16/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol ConverterPresentationLogic {
    func presentData(response: Converter.Model.Response.ResponseType)
}

class ConverterPresenter: ConverterPresentationLogic {
    weak var viewController: ConverterDisplayLogic?
    
    private var baseCurrency: Currency!
    private var indexPathes: [IndexPath] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        if Locale.current.identifier.starts(with: "ru") {
            dateFormatter.dateFormat = "d.MM.YYYY, hh:mm"
        } else {
            dateFormatter.dateFormat = "d.MM.YYYY, hh:mm a"
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
        }
        return dateFormatter
    }()
    
    func presentData(response: Converter.Model.Response.ResponseType) {
        switch response {
        case .converterCurrencies(let first, let second):
            baseCurrency = first
            let viewModel = buildConverterViewModel(first, second)
            viewController?.displayData(viewModel: .showConverterViewModel(viewModel))
            
        case .favoriteCurrencies(let currencies, let total, let totalIndex):
            var viewModel = buildFavoriteViewModel(currencies, total: total, totalIndex: totalIndex)
            viewModel.enumerated().forEach {
                if $0.element.index != totalIndex {
                    viewModel[$0.offset].setSelected(false)
                } else {
                    viewModel[$0.offset].setSelected(true)
                }
            }
            viewController?.displayData(viewModel: .showFavoriteViewModel(viewModel))

        case .favoriteCurrenciesPartUpdate(let currencies, let total, let totalIndex):
            var viewModel = buildFavoriteViewModel(currencies, total: total, totalIndex: totalIndex)
            indexPathes.removeAll()
            viewModel.enumerated().forEach {
                if $0.element.index != totalIndex {
                    viewModel[$0.offset].setSelected(false)
                    indexPathes.append(IndexPath(row: $0.element.index, section: 0))
                } else {
                    viewModel[$0.offset].setSelected(true)
                }
            }
            viewController?.displayData(viewModel: .updateFavoriteViewModel(viewModel, indexPathes: indexPathes))
        case .updateBaseCurrency(let base):
            baseCurrency = base
            
        case .error(let message):
            guard let message = message else { break }
            viewController?.displayData(viewModel: .showError(message: message))
            
        case .firstLoadComplete:
            viewController?.displayData(viewModel: .firstLoadComplete())
        }
    }
    
    private func restoreOrder(for favorite: [Currency]) -> [Currency] {
        var favoriteCopy = favorite
        let ordered = FavoriteOrderService.shared.fetchOrder()
        
        favorite.forEach { fav in
            if ordered.contains(where: { $0.currency == fav.currency }) {
                let orderIndex = ordered.firstIndex { $0.currency == fav.currency }
                let favoriteIndex = favoriteCopy.firstIndex { $0.currency == fav.currency }
                favoriteCopy.swapAt(orderIndex!, favoriteIndex!)
            }
        }
        return favoriteCopy
    }
    
    private func buildFavoriteViewModel(_ favorite: [Currency], total: Double, totalIndex: Int) -> [FavoriteConverterViewModel] {
        var viewModels = [FavoriteConverterViewModel]()
        let orderedCurrencies = restoreOrder(for: favorite)
        
        orderedCurrencies.enumerated().forEach { currency in
            let rate = currency.element.rate / baseCurrency.rate
            let totalSum = rate * total
            let roundedSum = AccuracyManager.shared.formatNumber(totalSum)
            var currenciesInfo = CurrenciesInfoService.shared.fetchCurrency()
            let cryptoCurrency =  CurrenciesInfoService.shared.fetchCrypto()
            currenciesInfo.append(contentsOf: cryptoCurrency)
            let title = currenciesInfo.first { $0.abbreviation == currency.element.currency }!
            let isSelected = currency.offset == totalIndex
            
            let viewModel = FavoriteConverterViewModel(
                currency: currency.element.currency,
                title: title.title,
                total: roundedSum,
                rate: currency.element.rate,
                isSelected: isSelected,
                index: currency.offset
            )
            viewModels.append(viewModel)
        }
        return viewModels
    }
    
    private func buildConverterViewModel(_ first: Currency, _ second: Currency) -> ConverterViewModel {
        let firstRate = Double(first.rate)
        let secondRate = Double(second.rate)

        let firstExchangeRate = secondRate / firstRate
        let secondExchangeRate = firstRate / secondRate
        let firstRoundedRate = AccuracyManager.shared.formatNumber(firstExchangeRate)
        let secondRoundedRate = AccuracyManager.shared.formatNumber(secondExchangeRate)

        let aSymbol = getSymbol(forCurrencyCode: first.currency) ?? first.currency
        let bSymbol = getSymbol(forCurrencyCode: second.currency) ?? second.currency

        let firstExchange = Exchange(index: 0, currency: first.currency,
                             rate: firstRate,
                             exchangeRate: firstExchangeRate,
                             regardingRate: "\(aSymbol)1=\(bSymbol)\(firstRoundedRate)")
        let secondExchange = Exchange(index: 0, currency: second.currency,
                              rate: secondRate,
                              exchangeRate: secondExchangeRate,
                              regardingRate: "\(bSymbol)1=\(aSymbol)\(secondRoundedRate)")

        let timestamp = UserDefaults.standard.integer(forKey: "updated")
        let updatedTitle = buildUpdatedTitle(from: timestamp)

        return ConverterViewModel(firstExchange: firstExchange,
                                  secondExchange: secondExchange,
                                  updated: updatedTitle)
    }
    
    private func getSymbol(forCurrencyCode code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        if locale.displayName(forKey: .currencySymbol, value: code) == code {
            let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: code)
        }
        return locale.displayName(forKey: .currencySymbol, value: code)
    }
    
    private func buildUpdatedTitle(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formattedDate = dateFormatter.string(from: date)
        return "\(R.string.localizable.updated()) - \(formattedDate)"
    }
}

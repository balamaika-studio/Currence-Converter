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

final class ConverterPresenter: ConverterPresentationLogic {
    
    weak var viewController: ConverterDisplayLogic?
    
    private var baseCurrency: Currency!
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        if Locale.current.identifier.starts(with: "ru") {
            dateFormatter.dateFormat = "LLL dd, yyyy, HH:mm"
        } else {
            dateFormatter.dateFormat = "LLL dd, yyyy, HH:mm a"
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
            
        case .favoriteCurrencies(let currencies, let total):
            let viewModel = buildFavoriteViewModel(currencies, total: total)
            viewController?.displayData(viewModel: .showFavoriteViewModel(viewModel))
            
        case .updateBaseCurrency(let base):
            baseCurrency = base
            
        case .error(let message):
            guard let message = message else { break }
            viewController?.displayData(viewModel: .showError(message: message))
        }
    }
    
    private func restoreOrder(for favorite: [Currency]) -> [Currency] {
        var favoriteCopy = favorite
        let ordered = FavoriteOrderService.shared.fetchOrder()
        
        favorite.forEach { fav in
            guard let orderIndex = ordered.firstIndex(where: { $0.currency == fav.currency }) else { return }
            guard let favoriteIndex = favoriteCopy.firstIndex(where: { $0.currency == fav.currency }) else { return }
            if orderIndex != favoriteIndex { favoriteCopy.swapAt(orderIndex, favoriteIndex) }
        }
        return favoriteCopy
    }
    
    private func buildFavoriteViewModel(_ favorite: [Currency], total: Double) -> [FavoriteConverterViewModel] {
        var viewModels = [FavoriteConverterViewModel]()
        let orderedCurrencies = restoreOrder(for: favorite)
        
        orderedCurrencies.forEach { currency in
            let rate = currency.rate / baseCurrency.rate
            let totalSum = rate * total
            let roundedSum = AccuracyManager.shared.formatNumber(totalSum)
            let symbol = CurrenciesInfoService.shared.getSymbol(forCurrencyCode: currency.currency) ?? ""
            let stringSum = "\(roundedSum) \(symbol)"
            guard let title = CurrenciesInfoService.shared.getInfo(by: currency)?.title else { return }
            let viewModel = FavoriteConverterViewModel(currency: currency.currency,
                                                       title: title,
                                                       total: stringSum,
                                                       rate: currency.rate)
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

        let aSymbol = CurrenciesInfoService.shared.getSymbol(forCurrencyCode: first.currency) ?? "Error"
        let bSymbol = CurrenciesInfoService.shared.getSymbol(forCurrencyCode: second.currency) ?? "Error"
        
        let firstExchange = Exchange(currency: first.currency,
                             rate: firstRate,
                             exchangeRate: firstExchangeRate,
                             regardingRate: "\(aSymbol)1=\(bSymbol)\(firstRoundedRate)")
        let secondExchange = Exchange(currency: second.currency,
                              rate: secondRate,
                              exchangeRate: secondExchangeRate,
                              regardingRate: "\(bSymbol)1=\(aSymbol)\(secondRoundedRate)")
        
        let timestamp = UserDefaults.standard.integer(forKey: "updated")
        let updatedTitle = buildUpdatedTitle(from: timestamp)
        
        return ConverterViewModel(firstExchange: firstExchange,
                                  secondExchange: secondExchange,
                                  updated: updatedTitle)
    }
    
    private func buildUpdatedTitle(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formattedDate = dateFormatter.string(from: date)
        return "\(R.string.localizable.updated()) - \(formattedDate)"
    }
}

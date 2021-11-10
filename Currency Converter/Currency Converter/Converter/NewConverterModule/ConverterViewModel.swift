//
//  ConverterViewModel.swift
//  Currency Converter
//
//  Created by Александр Томашевский on 17.10.2021.
//  Copyright © 2021 Kiryl Klimiankou. All rights reserved.
//

import Foundation
import RxCocoa
import Differentiator

protocol ConverterCellModelProtocol: Equatable {
    var currencyName: String { get }
    var currencyCode: String { get }
    var formattedCount: String { get }
}

extension ConverterCellModelProtocol {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.currencyCode == rhs.currencyCode
    }
}

private struct ConverterCellModel: ConverterCellModelProtocol {
    
    let currencyName: String
    let currencyCode: String
    let formattedCount: String
    
    init(item: ConverterServiceItemType) {
        currencyName = item.currency.currencyName ?? ""
        currencyCode = item.currency.currency
        formattedCount = AccuracyManager.shared.formatNumber(item.count)
    }
}

struct AnyConverterCellModel: ConverterCellModelProtocol {
    
    private let getCurrencyName: ()->String
    var currencyName: String {
        getCurrencyName()
    }
    
    private let getCurrencyCode: ()->String
    var currencyCode: String {
        getCurrencyCode()
    }
    
    let getFormattedCount: ()->String
    var formattedCount: String {
        getFormattedCount()
    }
    
    init<T: ConverterCellModelProtocol>(model: T) {
        getCurrencyName = { model.currencyName }
        getCurrencyCode = { model.currencyCode }
        getFormattedCount = { model.formattedCount }
    }
}

final class ConverterViewModel {
    
    private let service: ConverterServiceProtocol
    
    var sections: Driver<[SectionModel<String, AnyConverterCellModel>]> {
        service.currencies
            .asDriver()
            .map({
                let items = ($0.value ?? []).map({ AnyConverterCellModel(model: ConverterCellModel(item: $0)) })
                return [SectionModel(model: "", items: items)]
            })
    }
    
    var onFetcheFavoriteCurrencies: AcceptableObserver<Void> { service.onFetcheFavoriteCurrencies }
    var onChangeCountForCurrency: AcceptableObserver<(Double, String)> { service.onChangeCountForCurrency }
    var onAddFavoriteCurrency: AcceptableObserver<String> { service.onAddFavoriteCurrency }
    var activityIndicator: Driver<Bool> { service.isPending.asDriver() }
    
    init(service: ConverterServiceProtocol = ConverterService()) {
        self.service = service
        service.fetcheFavoriteCurrencies()
    }
    
    
}

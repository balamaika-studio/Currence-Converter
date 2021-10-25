//
//  ConverterViewModel.swift
//  Currency Converter
//
//  Created by Александр Томашевский on 17.10.2021.
//  Copyright © 2021 Kiryl Klimiankou. All rights reserved.
//

import Foundation
import RxCocoa

final class ConverterViewModel {
    
    private let service: ConverterServiceProtocol
    
    //private var _items = BehaviorRelay<[ConverterCellModelProtocol]>(value: [])
    var items: Driver<[ConverterCellModelProtocol]> {
        service.currencies.asDriver().map({ ($0.value ?? []).map({ ConverterCellModel(item: $0) }) })
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

//final class

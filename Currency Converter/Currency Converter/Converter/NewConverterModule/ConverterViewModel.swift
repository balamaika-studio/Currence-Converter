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
    
    private let service: CurrencyServiceProtocol
    
    private var _items = BehaviorRelay<[Currency]>(value: [])
    var items: Driver<[Currency]> { _items.asDriver() }
    
    init(service: CurrencyServiceProtocol = CurrencyService()) {
        self.service = service
        service.fetchCurrencies()
    }
    
    
}

//final class

//
//  CurrencyService.swift
//  Currency Converter
//
//  Created by Александр Томашевский on 11.09.2021.
//  Copyright © 2021 Kiryl Klimiankou. All rights reserved.
//

import RxSwift
import RxRelay

protocol CurrencyServiceProtocol {
    var isPending: Infallible<Bool> { get }
    var currencies: Infallible<CachedResult<ExchangeRatesHistoryResponse>> { get }
    var onFetchCurrencies: AcceptableObserver<Void> { get }
    var lastValidValue: ExchangeRatesHistoryResponse? { get }
    
    func fetchCurrencies()
}

final class CurrencyService: CurrencyServiceProtocol {
    
    typealias Result = CachedResult<ExchangeRatesHistoryResponse>
    
    private let networkManager = NetworkManager()
    private let currencyStore = JSONDataStoreManager.default(for: ExchangeRatesHistoryResponse.self)
    
    private let _isPending = BehaviorRelay<Bool>(value: false)
    var isPending: Infallible<Bool> { _isPending.asInfallible() }
    
    private lazy var _currencies = BehaviorRelay<Result>(value: .none)
    var currencies: Infallible<Result> { _currencies.asInfallible() }
    
    var lastValidValue: ExchangeRatesHistoryResponse? { _currencies.value.value }
    
    private(set) lazy var onFetchCurrencies = AcceptableObserver<Void> { self.fetchCurrencies() }
    
    func fetchCurrencies() {
        guard !_isPending.value else { return }
        _isPending.accept(true)
        networkManager.getQuotes { [weak self] response, error in
            guard let self = self else { return }
            defer { self._isPending.accept(false) }
            if let response = response {
                self._currencies.accept(.success(response))
                self.currencyStore.state = response
            } else {
                let error = error ?? "unknown error"
                self._currencies.accept(.error(error, cache: self.currencyStore.state))
            }
        }
    }
}

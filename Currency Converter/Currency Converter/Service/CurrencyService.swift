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

class DataServiceBase<Model: Codable> {
    
    typealias Result = CachedResult<Model>
    
    private let networkManager = NetworkManager()
    private let store = JSONDataStoreManager.default(for: Model.self)
    
    private let _isPending = BehaviorRelay<Bool>(value: false)
    var isPending: Infallible<Bool> { _isPending.asInfallible() }
    
    private lazy var _models = BehaviorRelay<Result>(value: .none)
    var models: Infallible<Result> { _models.asInfallible() }
    
    var lastValidValue: Model? { _models.value.value }
    
    private(set) lazy var onFetch = AcceptableObserver<Void> { self.fetch() }
    
    func fetch() {
        guard !_isPending.value else { return }
        _isPending.accept(true)
        loadDataFromNetowrk(with: networkManager) { [weak self] response, error in
            guard let self = self else { return }
            defer { self._isPending.accept(false) }
            if let response = response {
                self._models.accept(.success(response))
                self.store.state = response
            } else {
                let error = error ?? "unknown error"
                self._models.accept(.error(error, cache: self.store.state))
            }
        }
    }
    
    func loadDataFromNetowrk(with networkManager: NetworkManager, completion: @escaping ((_ response: Model?, _ error: String?)->Void)) {
        fatalError("This is abstract method, it must be implemented by subclasses")
    }
}

final class CurrencyService: DataServiceBase<ExchangeRatesHistoryResponse>, CurrencyServiceProtocol {
    
    var currencies: Infallible<CachedResult<ExchangeRatesHistoryResponse>> { models }
    
    var onFetchCurrencies: AcceptableObserver<Void> { onFetch }
    
    func fetchCurrencies() {
        fetch()
    }
    
    override func loadDataFromNetowrk(with networkManager: NetworkManager, completion: @escaping ((ExchangeRatesHistoryResponse?, String?) -> Void)) {
        networkManager.getQuotes(completion: completion)
    }
}

final class ExchangeService: DataServiceBase<ExchangeRatesHistoryResponse>, CurrencyServiceProtocol {
    
}

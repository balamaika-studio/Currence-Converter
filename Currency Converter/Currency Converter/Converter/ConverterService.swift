//
//  ConverterService.swift
//  Currency Converter
//
//  Created by Александр Томашевский on 18.10.2021.
//  Copyright © 2021 Kiryl Klimiankou. All rights reserved.
//

import RxSwift
import RxRelay

extension UserDefaults {
    
    private static let converterFavoriteCurrenciesKey = "CurrencyConverter.Converter.favoriteCurrencies"
    private static let converterBaseCountKey = "CurrencyConverter.Converter.baseCount"
    
    var favoriteCurrencies: [String] {
        get { stringArray(forKey: Self.converterFavoriteCurrenciesKey) ?? [] }
        set { set(newValue, forKey: Self.converterFavoriteCurrenciesKey) }
    }
    
    var converterBaseCount: Double {
        get { value(forKey: Self.converterBaseCountKey) as? Double ?? 1 }
        set { set(newValue, forKey: Self.converterBaseCountKey) }
    }
}

protocol ConverterServiceItemType {
    var currency: Currency { get }
    var count: Double { get }
}

struct ConverterServiceItem: ConverterServiceItemType {
    
    let currency: Currency
    let count: Double
    
    init(currency: Currency, baseCount: Double) {
        self.currency = currency
        self.count = currency.rate * baseCount
    }
}

protocol ConverterServiceProtocol: AnyObject {
    
    var currencies: Infallible<CachedResult<[ConverterServiceItemType]>> { get }
    var onFetcheFavoriteCurrencies: AcceptableObserver<Void> { get }
    var onChangeCountForCurrency: AcceptableObserver<(Double, String)> { get }
    var onAddFavoriteCurrency: AcceptableObserver<String> { get }
    var isPending: Infallible<Bool> { get }
    
    func fetcheFavoriteCurrencies()
    func set(count: Double, for currency: String)
    func set(position: Int, ofCurrency code: String)
    func add(favoriteCurrency code: String)
}

final class ConverterService: ConverterServiceProtocol {
    
    private let currencyService: CurrencyServiceProtocol
    private var baseCount: Double {
        get { UserDefaults.standard.converterBaseCount }
        set {
            UserDefaults.standard.converterBaseCount = newValue
            onChangeCurrencies.accept(())
        }
    }
    private var favoriteCurrenciesCodes: [String] {
        get { UserDefaults.standard.favoriteCurrencies }
        set {
            UserDefaults.standard.favoriteCurrencies = newValue
            onChangeCurrencies.accept(())
        }
    }
    
    private let onChangeCurrencies = PublishRelay<Void>()
    
    private(set) lazy var currencies: Infallible<CachedResult<[ConverterServiceItemType]>> = { [unowned self] in
        Observable.combineLatest(self.onChangeCurrencies, self.currencyService.currencies.asObservable())
            .map({ $0.1 })
            .map({ result in
                result.map(transform: {
                    self.map(currencyServiceModel: $0)
                })
            }).asInfallible(onErrorJustReturn: .none)
    }()
    
    private(set) lazy var onFetcheFavoriteCurrencies = AcceptableObserver<Void> { [unowned self] _ in self.fetcheFavoriteCurrencies() }
    private(set) lazy var onChangeCountForCurrency = AcceptableObserver<(Double, String)> { [unowned self] in self.set(count: $0.0, for: $0.1) }
    private(set) lazy var onAddFavoriteCurrency = AcceptableObserver<String> { [unowned self] in self.add(favoriteCurrency: $0) }
    
    var isPending: Infallible<Bool> { currencyService.isPending }
    
    init(currencyService: CurrencyServiceProtocol = CurrencyService()) {
        self.currencyService = currencyService
    }
    
    func fetcheFavoriteCurrencies() {
        currencyService.fetchCurrencies()
    }
    
    func set(count: Double, for currency: String) {
        guard let rate = currencyService.lastValidValue?.quotes.first(where: { $0.currency == currency })?.rate else { return }
        baseCount = count/rate
    }
    
    func set(position: Int, ofCurrency code: String) {
        guard let i = favoriteCurrenciesCodes.index(of: code) else { return }
        var codes = favoriteCurrenciesCodes
        codes.remove(at: i)
        codes.insert(code, at: position)
        favoriteCurrenciesCodes = codes
    }
    
    func add(favoriteCurrency code: String) {
        guard !favoriteCurrenciesCodes.contains(code) else { return }
        favoriteCurrenciesCodes.append(code)
    }
    
    private func map(currencyServiceModel model: ExchangeRatesHistoryResponse) -> [ConverterServiceItem] {
        favoriteCurrenciesCodes.compactMap({ code in
            model.quotes.first(where: { $0.currency == code }).map({ ConverterServiceItem(currency: $0, baseCount: self.baseCount) })
        })
    }
}

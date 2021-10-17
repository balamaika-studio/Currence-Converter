//
//  ConverterService.swift
//  Currency Converter
//
//  Created by Александр Томашевский on 18.10.2021.
//  Copyright © 2021 Kiryl Klimiankou. All rights reserved.
//

import RxSwift
import RxRelay

private extension UserDefaults {
    
    private let converterFavoriteCurrenciesKey = "CurrencyConverter.Converter.favoriteCurrencies"
    private let converterBaseCountKey = "CurrencyConverter.Converter.baseCount"
    
    var favoriteCurrencies: [String] {
        get { stringArray(forKey: converterFavoriteCurrenciesKey) ?? [] }
        set { set(newValue, forKey: converterFavoriteCurrenciesKey) }
    }
    
    var converterBaseCount: Double {
        get { double(forKey: converterBaseCountKey) ?? 1 }
        set { set(newValue, forKey: converterBaseCountKey) }
    }
}

struct ConverterServiceItem {
    
    let currency: Currency
    let count: Double
    
    init(currency: Currency, baseCount: Double) {
        self.count = currency.rate * baseCount
    }
}

protocol ConverterServiceProtocol {
    
    var currencies: Infallible<[CachedResult<ConverterServiceItem>]> { get }
    var onFetcheFavoriteCurrencies: AcceptableObserver<Void> { get }
    var onChangeCountForCurrency: AcceptableObserver<(Double, String)> { get }
    
    func fetcheFavoriteCurrencies()
    func set(count: Double, for currency: String)
}

final class ConverterService: ConverterServiceProtocol {
    
    private let currencyService: CurrencyServiceProtocol
    private var baseCount: Double {
        get { UserDefaults.standard.converterBaseCount }
        set { UserDefaults.standard.converterBaseCount = newValue }
    }
    private var favoriteCurrenciesCodes: [String] {
        get { UserDefaults.standard.favoriteCurrencies }
        set { UserDefaults.standard.favoriteCurrencies = newValue }
    }
    
    private(set) lazy var currencies: Infallible<CachedResult<[ConverterServiceItem]>> = { [unowned self] in
        self.currencyService.currencies.map({ result in
            result.map(transform: {
                self.map(currencyServiceModel: $0)
            })
        })
    }()
    
    func map(currencyServiceModel model: ExchangeRatesHistoryResponse) -> [ConverterServiceItem] {
        favoriteCurrenciesCodes.compactMap({ code in
            model.quotes.first(where: { $0.currency == code }).map({ ConverterServiceItem(currency: $0, baseCount: self.baseCount) })
        })
    }
    
    private(set) lazy var onFetcheFavoriteCurrencies = AcceptableObserver<Void> { [unowned self] _ in self.fetcheFavoriteCurrencies() }
    private(set) lazy var onChangeCountForCurrency = AcceptableObserver<(Double, String)> { [unowned self] in self.set(count: $0.0, for: $0.1) }
    
    init(currencyService: CurrencyServiceProtocol = CurrencyService()) {
        self.currencyService = currencyService
    }
    
    func fetcheFavoriteCurrencies() {
        currencyService.fetchCurrencies()
    }
    
    func set(count: Double, for currency: String) {
        guard let rate = _currencies.value.first(where: { $0.currency == currency }) else { return }
        baseCount = count/rate
        fetcheFavoriteCurrencies()
    }
}

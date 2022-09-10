//
//  GraphCryptoInteractor.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/17/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol GraphCryptoBusinessLogic {
    func makeRequest(request: GraphCrypto.Model.Request.RequestType)
}

class GraphCryptoInteractor: GraphCryptoBusinessLogic, ChoiceDataStore {
    var selectedCurrency: Currency?
    var presenter: GraphCryptoPresentationLogic?
    var networkManager: NetworkManager!
    
    init() {
        self.networkManager = NetworkManager()
    }
    
    func makeRequest(request: GraphCrypto.Model.Request.RequestType) {
        switch request {
        case .getGraphCryptoPeriods:
            let periods = PeriodService.shared.buildGraphPeriodModels()
            presenter?.presentData(response: .GraphCryptoPeriods(periods))
            
        case .getDefaultConverter:
            let converter = CurrenciesInfoService.shared.getGraphDefaultCryptocurrencies()
            presenter?.presentData(response: .defaultConverter(converter))
            
        case .updateConverterCurrency:
            guard let newCurrency = selectedCurrency else { break }
            presenter?.presentData(response: .newConverterCurrency(newCurrency))
            
        case .loadGraphCryptoData(let base, let relative, let period):
            let interval = buildGraphCryptoRequestInterval(period: period)
            if base == relative {
                let quotes = self.buildEqualTimeFrameQuotes(period: period, currency: base)
                self.presenter?.presentData(response: .GraphCryptoData(quotes.sorted(by: <), period: period))
            }
            
            networkManager.getCryptoGraphsQuotes(base: base, related: relative, start: interval.startDate, end: interval.endDate) { response, errorMessage in
                guard let answer = response?.quotes else {
                    print(errorMessage ?? "Error Load GraphCrypto data")
                    return
                }
                self.presenter?.presentData(response: .GraphCryptoData(answer.sorted(by: <), period: period))
            }
        }
        
    }
    
    private func buildGraphCryptoRequestInterval(period: GraphPeriod) -> GraphPeriodInterval {
        var startInterval = period.interval
        let testRange = Period.week.range(to: .halfMonth)
        
        if testRange.contains(startInterval) {
            let calendar = Calendar.current
            var availableDaysCount = 0
            var currentInterval = 0
            
            let myPeriod = Period(rawValue: startInterval) ?? .month
            let dayCount = myPeriod.availableDayCount

            while availableDaysCount < dayCount {
                let date = Date(timeIntervalSinceNow: TimeInterval(-currentInterval))
                if !calendar.isDateInWeekend(date) {
                    availableDaysCount += 1
                }
                currentInterval += 86400
            }
            startInterval = currentInterval
        }
        
        let startDate = Date(timeIntervalSinceNow: TimeInterval(-startInterval))
        let endDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let start = dateFormatter.string(from: startDate)
        let end = dateFormatter.string(from: endDate)
        return GraphPeriodInterval(startDate: start, endDate: end)
    }
    
    private func buildEqualTimeFrameQuotes(period: GraphPeriod, currency symbol: String) -> [TimeFrameQuote] {
        let daysCount = period.interval / 86400
        var currentDate = Date(timeIntervalSinceNow: TimeInterval(-period.interval))
        var days = [Date]()
        days.append(currentDate)
        
        for _ in (1..<daysCount) {
            let newDate = Date(timeInterval: TimeInterval(86400), since: currentDate)
            currentDate = newDate
            days.append(newDate)
        }
                
        var quotes = [TimeFrameQuote]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for date in days {
            let formattedDate = dateFormatter.string(from: date)
            let quote = TimeFrameQuote(currency: symbol, rate: 1.0, date: formattedDate, index: 0)
            quotes.append(quote)
        }
        return quotes
    }
}

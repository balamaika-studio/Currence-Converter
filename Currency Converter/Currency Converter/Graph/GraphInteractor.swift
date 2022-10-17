//
//  GraphInteractor.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/17/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol GraphBusinessLogic {
    func makeRequest(request: Graph.Model.Request.RequestType)
}

class GraphInteractor: GraphBusinessLogic, ChoiceDataStore {
    var selectedCurrency: Currency?
    var presenter: GraphPresentationLogic?
    var networkManager: NetworkManager!
    var storage: StorageContext!
    
    init(storage: StorageContext = try! RealmStorageContext()) {
        self.networkManager = NetworkManager()
        self.storage = storage
    }
    
    func makeRequest(request: Graph.Model.Request.RequestType) {
        switch request {
        case .getGraphPeriods:
            let periods = PeriodService.shared.buildGraphPeriodModels()
            presenter?.presentData(response: .graphPeriods(periods))
            
        case .getDefaultConverter:
            let converter = CurrenciesInfoService.shared.getGraphDefaultCurrencies()
            presenter?.presentData(response: .defaultConverter(converter))
            
        case .updateConverterCurrency:
            guard let newCurrency = selectedCurrency else { break }
            presenter?.presentData(response: .newConverterCurrency(newCurrency))
            
        case .loadGraphData(let base, let relative, let period):
            let interval = buildGraphRequestInterval(period: period)
            if base == relative {
                let quotes = self.buildEqualTimeFrameQuotes(period: period, currency: base)
                self.presenter?.presentData(response: .graphData(quotes.sorted(by: <), period: period))
            }

            var pairsModels: [RealmPairCurrencyV2] = []
            storage.fetch(RealmPairCurrencyV2.self, predicate: nil, sorted: nil) { pairs in
                pairsModels = pairs
            }

            if let pairModel = pairsModels.first(where: { curPair in
                (curPair.base == base && curPair.relative == relative) ||
                (curPair.base == relative && curPair.relative == base)
            }) {
                networkManager.getForexGraphsQuotes(id: pairModel.currencyPairId ?? "", start: interval.startDate, end: interval.endDate) { response, errorMessage in
                    guard let answer = response?.quotes else {
                        print(errorMessage ?? "Error Load graph data")
                        return
                    }
                    if answer.isEmpty {
                        self.networkManager.getCryptoGraphsQuotes(id: pairModel.currencyPairId ?? "", start: interval.startDate, end: interval.endDate) { response, errorMessage in
                            guard let answer = response?.quotes else {
                                print(errorMessage ?? "Error Load GraphCrypto data")
                                return
                            }
                            var currentAnswer = answer
                            if pairModel.base != base {
                                currentAnswer = []
                                answer.forEach {
                                    var quote = $0
                                    quote.rate = (1 / $0.rate)
                                    currentAnswer.append(quote)
                                }
                            }
                            self.presenter?.presentData(response: .graphData(currentAnswer.sorted(by: <), period: period))
                        }
                    } else {
                        var currentAnswer = answer
                        if pairModel.base != base {
                            currentAnswer = []
                            answer.forEach {
                                var quote = $0
                                quote.rate = (1 / $0.rate)
                                currentAnswer.append(quote)
                            }
                        }
                        self.presenter?.presentData(response: .graphData(currentAnswer.sorted(by: <), period: period))
                    }
                }
            }
        }
    }
    
    private func buildGraphRequestInterval(period: GraphPeriod) -> GraphPeriodInterval {
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

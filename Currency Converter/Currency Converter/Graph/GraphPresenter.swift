//
//  GraphPresenter.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/17/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol GraphPresentationLogic {
    func presentData(response: Graph.Model.Response.ResponseType)
}

class GraphPresenter: GraphPresentationLogic {
    weak var viewController: GraphDisplayLogic?
    private var graphPeriod: GraphPeriod!
    
    func presentData(response: Graph.Model.Response.ResponseType) {
        switch response {
        case .graphPeriods(let periods):
            viewController?.displayData(viewModel: .showGraphPeriods(periods))
            
        case .defaultConverter(let converterModel):
            viewController?.displayData(viewModel: .showGraphConverter(converterModel))
            
        case .newConverterCurrency(let currency):
            guard let model = buildNewModel(with: currency) else { break }
            viewController?.displayData(viewModel: .updateConverter(newModel: model))
            
        case .graphData(let timeframeQuotes, let graphPeriod):
            self.graphPeriod = graphPeriod
            let viewModel = buildGraphViewModel(timeframeQuotes)
            print(viewModel)
            viewController?.displayData(viewModel: .showGraphData(viewModel))
        }
    }
    
    private func buildNewModel(with currency: Currency) -> ChoiceCurrencyViewModel? {
        guard let info = CurrenciesInfoService.shared.getInfo(by: currency) else {
            return nil
        }
        return ChoiceCurrencyViewModel(currency: info.abbreviation, title: info.title)
    }
    
    private func buildGraphViewModel(_ quotes: [TimeFrameQuote]) -> GraphViewModel {
        guard let period = Period(rawValue: graphPeriod.interval) else {
            fatalError()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dates = quotes.compactMap { dateFormatter.date(from: $0.date) }
        
        var labels = [Double]()
        var marks = [String]()
        var data = quotes.map { $0.rate }
        
        var visiableIndexes = [Double]()
                
        switch period {
        case .week:
            dateFormatter.dateFormat = "dd.MM"
            marks = dates.compactMap { dateFormatter.string(from: $0) }
            labels = (0...marks.count).compactMap { Double($0) }
            data.append(data.last!)
            
            visiableIndexes = labels
            break
            
        case .halfMonth:
            dateFormatter.dateFormat = "dd.MM"
            marks = dates.compactMap { dateFormatter.string(from: $0) }
            labels = (0...marks.count).compactMap { Double($0) }
            data.append(data.last!)
            
            let mid = labels.count / 2
            
            marks = [marks.first!, marks[mid/2],
                        marks[mid], marks[mid + mid/2], marks.last!]

            visiableIndexes = [labels.first!, labels[mid/2],
                               labels[mid], labels[mid + mid/2]]
            visiableIndexes.append(contentsOf: Array<Double>(repeating: labels.last!, count: 2))
            break
            
        case .month:
            dateFormatter.dateFormat = "dd.MM"
            marks = dates.compactMap { dateFormatter.string(from: $0) }
            labels = (0...marks.count).compactMap { Double($0) }
            data.append(data.last!)
            
            let mid = labels.count / 2
            
            marks = [marks.first!, marks[mid/2],
                        marks[mid], marks[mid + mid/2], marks.last!]

            visiableIndexes = [labels.first!, labels[mid/2],
                               labels[mid], labels[mid + mid/2]]
            visiableIndexes.append(contentsOf: Array<Double>(repeating: labels.last!, count: 2))
            break
            
        case .threeMonths:
            dateFormatter.dateFormat = "MMM."
            marks = dates.compactMap { dateFormatter.string(from: $0) }
            labels = (0...marks.count).compactMap { Double($0) }
            
            let newArray = haha(marks)
            visiableIndexes = givemeIndex(newArray).map { Double($0) }
            marks = newArray.uniques
            data.append(data.last!)
            break
            
        case .halfYear:
            
            break
            
        case .nineMonths:
            
            break
            
        case .year:
            break
        }
        

        var vm = GraphViewModel(labels: labels, data: data, dates: marks)
        vm.visiableLabels = visiableIndexes
        return vm
    }
    
    // оcтавить только 3 месяца
    private func haha(_ arr: [String]) -> [String] {
        var haha = [[String]]()
        arr.uniques.forEach { month in
            haha.append(arr.filter { $0 == month })
        }
        
        while haha.count > 3 {
            let minHaha = haha.min { $0.count < $1.count }
            haha.removeAll { $0.count == minHaha!.count }
        }
        
        return haha.flatMap { $0 }
    }
    
    private func givemeIndex(_ arr: [String]) -> [Int] {
        var indexes = [Int]()
        arr.uniques.forEach { month in
            if let monthIndex = arr.firstIndex(where: { $0 == month }) {
                let index = Int(monthIndex)
                indexes.append(index)
            }
        }
        return indexes
    }
    
    private func getCorrectXLabels(_ vm: GraphViewModel) -> GraphViewModel {
        let count = vm.dates.count
        
        print()
        print("Count = \(count)")
        print()
        
        var newDates = [String]()
        var visiableIndexes = [Double]()
        
        if count >= 0 && count <= 5 {
            print(5)
            newDates = vm.dates
            visiableIndexes = vm.labels
        } else if count > 5 && count <= 15 {
            print(15)
            let mid = vm.labels.count / 2
            
            newDates = [vm.dates.first!, vm.dates[mid/2],
                        vm.dates[mid], vm.dates[mid + mid/2], vm.dates.last!]

            visiableIndexes = [vm.labels.first!, vm.labels[mid/2],
                               vm.labels[mid], vm.labels[mid + mid/2]]
            visiableIndexes.append(contentsOf: Array<Double>(repeating: vm.labels.last!, count: 2))
        } else if count > 15 && count <= 31 {
            print("1 Month")
            let mid = vm.labels.count / 2
            
            newDates = [vm.dates.first!, vm.dates[mid/2],
                        vm.dates[mid], vm.dates[mid + mid/2], vm.dates.last!]

            visiableIndexes = [vm.labels.first!, vm.labels[mid/2],
                               vm.labels[mid], vm.labels[mid + mid/2]]
            visiableIndexes.append(contentsOf: Array<Double>(repeating: vm.labels.last!, count: 2))
        } else if count > 31 && count <= 93 {
            print("3 Month")
            let mid = vm.labels.count / 2
            
            newDates = ["Mart", "April", "September"]
            // найти названия месяцев, которые входят в диапазон
            // найти индексы дат, когда меняется месяц
            
            visiableIndexes = [vm.labels.first!, vm.labels[mid]]
            visiableIndexes.append(contentsOf: Array<Double>(repeating: vm.labels.last!, count: 2))
        } else if count > 93 && count <= 186 {
            print("6 Month")
        } else if count > 186 && count <= 279 {
            print("9 Month")
        } else {
            print("1 YEAR")
        }
        
        var res = GraphViewModel(labels: vm.labels, data: vm.data, dates: newDates)
        res.visiableLabels = visiableIndexes
        return res
    }
}

// TODO: - Replace
extension Array where Element: Hashable {
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}

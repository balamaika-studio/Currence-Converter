//
//  ChoiceInteractor.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/17/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol ChoiceBusinessLogic {
    func makeRequest(request: Choice.Model.Request.RequestType)
}

protocol ChoiceDataStore {
    var selectedCurrency: Currency? { get set }
}

class ChoiceInteractor: ChoiceBusinessLogic, ChoiceDataStore {
    // MARK: - Data Store
    var selectedCurrency: Currency?
    
    var presenter: ChoicePresentationLogic?
    var service: ChoiceService?
    
    var currencies: [Currency]!
    
    func makeRequest(request: Choice.Model.Request.RequestType) {
        if service == nil {
            service = ChoiceService()
        }
        
        switch request {
        case .loadCurrencies:
            let network: Networking = NetworkService()
            network.fetchData { [weak self] (data) in
                
                // load data from xml
                let logic = ECBParser()
                let parser: CurrencyParsing = ParsingService(parseLogic: logic)
                guard let data = data else {
                    print("Internet error")
                    return
                }
                let cube = parser.parse(data: data)
                self?.currencies = cube
                
                // load data from json
                let path = Bundle.main.path(forResource: "currenciesNames", ofType: ".json")!
                let fileUrl = URL(fileURLWithPath: path)
                let data2 = try? Data(contentsOf: fileUrl, options: .mappedIfSafe)
                let info = try? JSONSerialization.jsonObject(with: data2!, options: [])
                let gg = info as? [String: String]
                let answer = gg?.map { CurrencyInfo(abbreviation: $0, title: $1) }
                
                let haha = cube.filter { value in
                    let abb = answer?.contains { $0.abbreviation == value.currency }
                    return abb ?? false
                }
                
                var result = [ChoiceCurrencyViewModel]()
                
                haha.forEach { (value) in
                    let abababa = ChoiceCurrencyViewModel(currency: value.currency,
                                                          title: answer!.first { $0.abbreviation == value.currency }!.title)
                    result.append(abababa)
                }
                
                result.forEach { print($0) }
                
                self?.presenter?.presentData(response: .currencies(result))
            }
        case .chooseCurrency(let viewModel):
            selectedCurrency = currencies.first { $0.currency == viewModel.currency }
        default:
            break
        }
        
    }
    
}

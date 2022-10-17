//
//  CurrencyRatesModels.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/9/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

enum CurrencyRates {
    
    enum Model {
        struct Request {
            enum RequestType {
                case loadCurrencyRateChanges
                case addRelative(CurrencyPairViewModel)
                case removeRelative(CurrencyPairViewModel)
            }
        }
        struct Response {
            enum ResponseType {
                case currencies(_ live: [RealmCurrencyV2],
                                _ historical: [RealmCurrencyV2],
                                _ relatives: [RealmExchangeRateV2])
                case createViewModel(_ response: [CandleResponse])
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case showCurrencyRatesViewModel(_ viewModels: [CurrencyRatesViewModel])
            }
        }
    }
    
}

struct CurrencyRatesViewModel: CurrencyPairViewModel {
    var realmId: String
    var leftCurrency: String
    var rightCurrency: String
    var change: Change
    var rate: String
    var isSelected: Bool
    
    init(leftCurrency: String,rightCurrency: String , change: Change, rate: String) {
        self.leftCurrency = leftCurrency
        self.rightCurrency = rightCurrency
        self.change = change
        self.rate = rate
        realmId = String()
        isSelected = Bool()
    }
}

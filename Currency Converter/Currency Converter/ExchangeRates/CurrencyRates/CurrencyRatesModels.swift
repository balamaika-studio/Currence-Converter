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
            }
        }
        struct Response {
            enum ResponseType {
                case currencies(_ live: [Currency],
                                _ historical: [Currency],
                                _ relatives: [RealmExchangeRate])
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
    var relation: String
    var change: Change
    var rate: String
    var isSelected: Bool
    
    init(relation: String, change: Change, rate: String) {
        self.relation = relation
        self.change = change
        self.rate = rate
        realmId = String()
        isSelected = Bool()
    }
}

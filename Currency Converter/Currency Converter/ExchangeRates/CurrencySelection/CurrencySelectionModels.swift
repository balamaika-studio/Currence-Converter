//
//  CurrencySelectionModels.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/9/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

enum CurrencySelection {
    
    enum Model {
        struct Request {
            enum RequestType {
                case loadRelatives
                case addRelative(CurrencyPairViewModel)
                case removeRelative(CurrencyPairViewModel)
            }
        }
        struct Response {
            enum ResponseType {
                case relatives(_ relatives: [RealmExchangeRate])
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case showRelatives([CurrencyPairViewModel])
            }
        }
    }
    
}

struct CurrencySelectionViewModel: CurrencyPairViewModel {
    var realmId: String
    var leftCurrency: String
    var rightCurrency: String
    var change: Change
    var rate: String
    var isSelected: Bool
    
    init(id: String, leftCurrency: String, rightCurrency: String, isSelected: Bool) {
        self.realmId = id
        self.leftCurrency = leftCurrency
        self.rightCurrency = rightCurrency
        self.isSelected = isSelected
        change = .stay
        rate = ""
    }
}

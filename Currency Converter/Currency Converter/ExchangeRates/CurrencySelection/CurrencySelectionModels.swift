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
    var relation: String
    var change: Change
    var rate: String
    var isSelected: Bool
    
    init(id: String, relation: String, isSelected: Bool) {
        self.realmId = id
        self.relation = relation
        self.isSelected = isSelected
        change = .stay
        rate = ""
    }
}

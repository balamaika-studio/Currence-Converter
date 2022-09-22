//
//  ChoiceModels.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/17/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

enum Choice {
    
    enum Model {
        struct Request {
            enum RequestType {
                case loadCurrencies(forGraph: Bool = false, isCrypto: Bool = false, oppositeCurrency: String)
                case chooseCurrency(viewModel: ChoiceCurrencyViewModel)
                case filter(title: String)
            }
        }
        struct Response {
            enum ResponseType {
                case currencies([Currency], [CurrencyInfo], [RealmPairCurrency], String)
                case filter(title: String)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayCurrencies(_: [ChoiceCurrencyViewModel])
            }
        }
    }
    
}


struct ChoiceCurrencyViewModel {
    let currency: String
    let title: String
}

extension ChoiceCurrencyViewModel: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.currency == rhs.currency
    }
}

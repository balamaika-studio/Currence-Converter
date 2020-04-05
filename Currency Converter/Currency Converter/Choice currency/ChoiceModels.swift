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
                case loadCurrencies
                case chooseCurrency(viewModel: ChoiceCurrencyViewModel)
            }
        }
        struct Response {
            enum ResponseType {
                case currencies([RealmCurrency], [CurrencyInfo])
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

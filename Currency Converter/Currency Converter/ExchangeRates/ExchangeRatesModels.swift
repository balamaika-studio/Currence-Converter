//
//  ExchangeRatesModels.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/9/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

enum ExchangeRates {
    
    enum Model {
        struct Request {
            enum RequestType {
                case configureExchangeRates
            }
        }
        struct Response {
            enum ResponseType {
                case some
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case some
            }
        }
    }
    
}

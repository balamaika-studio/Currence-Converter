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
                case addRelative(RealmExchangeRate)
                case removeRelative(RealmExchangeRate)
            }
        }
        struct Response {
            enum ResponseType {
                case relatives(_ relatives: [RealmExchangeRate])
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case showRelatives([RealmExchangeRate])
            }
        }
    }
    
}

//struct CurrencySelectionViewModel {
//    let base: String
//    let relative: String
//    let isSelected: Bool
//}

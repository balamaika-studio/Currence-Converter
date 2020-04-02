//
//  FavoriteModels.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/26/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

enum Favorite {
    
    enum Model {
        struct Request {
            enum RequestType {
                case loadCurrencies
            }
        }
        struct Response {
            enum ResponseType {
                case currencies([FavoriteViewModel])
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case showCurrencies([FavoriteViewModel])
            }
        }
    }
    
}

struct FavoriteViewModel {
    let currency: String
    let title: String
}

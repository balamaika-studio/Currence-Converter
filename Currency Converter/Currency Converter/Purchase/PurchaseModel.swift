//
//  SplashModel.swift
//  Currency Converter
//
//  Created by Vlad Sys on 15.05.23.
//  Copyright © 2023 Kiryl Klimiankou. All rights reserved.
//

import StoreKit

enum Purchase {
    
    enum Model {
        struct Request {
            enum RequestType {
                case purchases
            }
        }
        struct Response {
            enum ResponseType {
                case products(_ products: [SKProduct])
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case products(_ products: [SKProduct])
            }
        }
    }
    
}

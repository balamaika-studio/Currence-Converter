//
//  SettingsModels.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/20/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit
import StoreKit

enum Settings {
    
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

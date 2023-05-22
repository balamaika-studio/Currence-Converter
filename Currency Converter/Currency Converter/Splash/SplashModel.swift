//
//  SplashModel.swift
//  Currency Converter
//
//  Created by Vlad Sys on 15.05.23.
//  Copyright © 2023 Kiryl Klimiankou. All rights reserved.
//

import Foundation

enum Splash {
    
    enum Model {
        struct Request {
            enum RequestType {
                case loadCurrencies()
            }
        }
        struct Response {
            enum ResponseType {
                case stopLoading()
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case stopLoading()
            }
        }
    }
    
}

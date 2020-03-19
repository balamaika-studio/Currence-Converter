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
      }
    }
    struct Response {
      enum ResponseType {
        case currencies(_: [ChoiceCurrencyViewModel])
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

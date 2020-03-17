//
//  ChoiceInteractor.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/17/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol ChoiceBusinessLogic {
  func makeRequest(request: Choice.Model.Request.RequestType)
}

class ChoiceInteractor: ChoiceBusinessLogic {

  var presenter: ChoicePresentationLogic?
  var service: ChoiceService?
  
  func makeRequest(request: Choice.Model.Request.RequestType) {
    if service == nil {
      service = ChoiceService()
    }
  }
  
}

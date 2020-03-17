//
//  ChoicePresenter.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/17/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol ChoicePresentationLogic {
  func presentData(response: Choice.Model.Response.ResponseType)
}

class ChoicePresenter: ChoicePresentationLogic {
  weak var viewController: ChoiceDisplayLogic?
  
  func presentData(response: Choice.Model.Response.ResponseType) {
  
  }
  
}

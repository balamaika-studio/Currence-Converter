//
//  OfflinePresenter.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 5/22/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol OfflinePresentationLogic {
    func presentData(response: Offline.Model.Response.ResponseType)
}

class OfflinePresenter: OfflinePresentationLogic {
    weak var viewController: OfflineDisplayLogic?
    
    func presentData(response: Offline.Model.Response.ResponseType) {
        
    }
    
}

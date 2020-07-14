//
//  OfflineInteractor.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 5/22/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol OfflineBusinessLogic {
    func makeRequest(request: Offline.Model.Request.RequestType)
}

class OfflineInteractor: OfflineBusinessLogic {
    
    var presenter: OfflinePresentationLogic?
    var service: OfflineService?
    
    func makeRequest(request: Offline.Model.Request.RequestType) {
        if service == nil {
            service = OfflineService()
        }
    }
    
}

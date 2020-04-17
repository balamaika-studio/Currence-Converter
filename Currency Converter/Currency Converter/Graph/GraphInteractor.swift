//
//  GraphInteractor.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/17/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol GraphBusinessLogic {
    func makeRequest(request: Graph.Model.Request.RequestType)
}

class GraphInteractor: GraphBusinessLogic {
    
    var presenter: GraphPresentationLogic?
    var service: GraphService?
    
    func makeRequest(request: Graph.Model.Request.RequestType) {
        if service == nil {
            service = GraphService()
        }
    }
    
}

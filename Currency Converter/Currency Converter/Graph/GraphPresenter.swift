//
//  GraphPresenter.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/17/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol GraphPresentationLogic {
    func presentData(response: Graph.Model.Response.ResponseType)
}

class GraphPresenter: GraphPresentationLogic {
    weak var viewController: GraphDisplayLogic?
    
    func presentData(response: Graph.Model.Response.ResponseType) {
        
    }
    
}

//
//  GraphSegmentInteractor.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/26/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol GraphSegmentBusinessLogic {
}

class GraphSegmentInteractor: GraphSegmentBusinessLogic {
    
    var presenter: GraphSegmentPresentationLogic?
    var storage: StorageContext!
    
    init(storage: StorageContext = try! RealmStorageContext()) {
        self.storage = storage
    }
}


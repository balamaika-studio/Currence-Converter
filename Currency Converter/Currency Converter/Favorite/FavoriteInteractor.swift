//
//  FavoriteInteractor.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/26/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol FavoriteBusinessLogic {
    func makeRequest(request: Favorite.Model.Request.RequestType)
}

class FavoriteInteractor: FavoriteBusinessLogic {
    
    var presenter: FavoritePresentationLogic?
    var service: FavoriteService?
    
    func makeRequest(request: Favorite.Model.Request.RequestType) {
        if service == nil {
            service = FavoriteService()
        }
        
        switch request {
        case .loadCurrencies:
            let manager = NetworkManager()
            manager.getQuotes { [weak self] result, error in
                guard let self = self,
                    let quotes = result else { return }
                self.presenter?.presentData(response: .currencies(quotes))
            }
        }
    }
    
}

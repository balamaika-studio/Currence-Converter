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
            manager.getQuotes { [weak self] quotes, error in
                guard let self = self,
                    let quotes = quotes else { return }
                
                // load data from json
                let path = Bundle.main.path(forResource: "currenciesNames", ofType: ".json")!
                let fileUrl = URL(fileURLWithPath: path)
                let data2 = try? Data(contentsOf: fileUrl, options: .mappedIfSafe)
                let info = try? JSONSerialization.jsonObject(with: data2!, options: [])
                let gg = info as? [String: String]
                let answer = gg?.map { CurrencyInfo(abbreviation: $0, title: $1) }

                let haha = quotes.filter { value in
                    let abb = answer?.contains { $0.abbreviation == value.currency }
                    return abb ?? false
                }
                
                var result = [FavoriteViewModel]()

                haha.forEach { value in
                    let abababa = FavoriteViewModel(currency: value.currency,
                                                          title: answer!.first { $0.abbreviation == value.currency }!.title)
                    result.append(abababa)
                }

                result.forEach { print($0) }
                
                self.presenter?.presentData(response: .currencies(result))
            }
        }
    }
    
}

//
//  FavoriteCryptocurrencyPresenter.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/26/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol SplashPresentationLogic {
    func presentData(response: Splash.Model.Response.ResponseType)
}

class SplashPresenter: SplashPresentationLogic {
    weak var viewController: SplashDisplayLogic?
    
    func presentData(response: Splash.Model.Response.ResponseType) {
        
        switch response {
        case .stopLoading:
            viewController?.displayData(viewModel: .stopLoading())
            
        }
    }
}

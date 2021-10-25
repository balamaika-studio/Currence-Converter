//
//  FavoriteModels.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/26/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

enum Favorite {
    
    enum Model {
        struct Request {
            enum RequestType {
                case loadCurrencies
                case addFavorite(FavoriteViewModel)
                case removeFavorite(FavoriteViewModel)
                case filter(title: String)
            }
        }
        struct Response {
            enum ResponseType {
                case currencies([Currency])
                case filter(title: String)
                case update(viewModel: FavoriteViewModel, isSelected: Bool)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case showCurrencies([FavoriteViewModel])
            }
        }
    }
    
}

struct FavoriteViewModel {
    let currency: String
    let title: String
    var isSelected: Bool
}

extension FavoriteViewModel: Equatable {
    static func == (lhs: FavoriteViewModel, rhs: FavoriteViewModel) -> Bool {
        return lhs.currency == rhs.currency
    }
}

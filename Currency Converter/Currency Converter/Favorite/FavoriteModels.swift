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
                case loadCurrenciesConverter
                case loadCurrenciesExchange(Relative?, Bool)
                case addFavorite(FavoriteViewModel)
                case removeFavorite(FavoriteViewModel)
                case filter(title: String)
            }
        }
        struct Response {
            enum ResponseType {
                case currenciesConverter([RealmCurrencyV2], [CurrencyInfo], [RealmPairCurrencyV2])
                case currenciesExchange([RealmCurrencyV2], [CurrencyInfo], [RealmPairCurrencyV2], String)
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

struct FavoriteViewModel: Hashable {
    let currency: String
    let title: String
    var isSelected: Bool
    var isFree: Bool
}

extension FavoriteViewModel: Equatable {
    static func == (lhs: FavoriteViewModel, rhs: FavoriteViewModel) -> Bool {
        return lhs.currency == rhs.currency
    }
}

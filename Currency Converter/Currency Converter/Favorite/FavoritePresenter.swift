//
//  FavoritePresenter.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/26/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol FavoritePresentationLogic {
    func presentData(response: Favorite.Model.Response.ResponseType)
}

class FavoritePresenter: FavoritePresentationLogic {
    weak var viewController: FavoriteDisplayLogic?
    
    private var quotes: [FavoriteViewModel]!
    private var filteredQuotes: [FavoriteViewModel]?
    
    func presentData(response: Favorite.Model.Response.ResponseType) {
        
        // TODO: - Replace to functions
        
        switch response {
        case .currencies(let currencies):
            quotes = currencies.compactMap {
                guard let name = $0.currencyName else { return nil }
                let viewModel = FavoriteViewModel(currency: $0.currency, title: name, isSelected: $0.isFavorite)
                return viewModel
            }.sorted { $0.title < $1.title }
            viewController?.displayData(viewModel: .showCurrencies(quotes))
            
        case .update(let viewModel, let isSelected):
            let index = quotes.firstIndex(of: viewModel)!
            quotes[index].isSelected = isSelected
            
            if let filteredQuotes = filteredQuotes, !filteredQuotes.isEmpty {
                let filterIndex = filteredQuotes.firstIndex(of: viewModel)!
                self.filteredQuotes![filterIndex].isSelected = isSelected
            }
            
            let result = filteredQuotes == nil ? quotes : filteredQuotes
            viewController?.displayData(viewModel: .showCurrencies(result ?? []))
            
        case .filter(let text):
            let filter = text.lowercased()
            let filteredQuotes = text.isEmpty ? quotes : quotes.filter { quote in
                let title = quote.title.lowercased()
                let currency = quote.currency.lowercased()
                return title.contains(filter) || currency.contains(filter)
            }
            self.filteredQuotes = filteredQuotes
            viewController?.displayData(viewModel: .showCurrencies(filteredQuotes ?? []))
        }
    }
}

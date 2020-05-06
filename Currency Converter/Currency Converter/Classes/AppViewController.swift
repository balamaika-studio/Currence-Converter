//
//  AppViewController.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/25/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

enum AppViewController {
    case converter
    case favorite
    case exchangeRates
    case graph
    case settings
    
    var viewController: UIViewController {
        var navigationController = AppNavigationController()
        switch self {
        case .converter:
            let converterViewController = ConverterViewController(nib: R.nib.converterViewController)
            navigationController = AppNavigationController(rootViewController: converterViewController)
            navigationController.navigationBar.topItem?.title = "Конвертер валют"
            let tabItem = UITabBarItem(title: "Конвертер",
                         image: R.image.converterDeselected(),
                         selectedImage: R.image.converterSelected())
            navigationController.tabBarItem = tabItem
            
        case .favorite:
            let favoriteViewController = FavoriteViewController(nib: R.nib.favoriteViewController)
            navigationController = AppNavigationController(rootViewController: favoriteViewController)
            navigationController.navigationBar.topItem?.title = "Избранное"
            let tabItem = UITabBarItem(title: "Избранное",
            image: R.image.favoriteDeselected(),
            selectedImage: R.image.favoriteSelected())
            
            navigationController.tabBarItem = tabItem
            
        case .exchangeRates:
            let exchangeRatesViewController = ExchangeRatesViewController(nib: R.nib.exchangeRatesViewController)
            navigationController = AppNavigationController(rootViewController: exchangeRatesViewController)
            navigationController.navigationBar.topItem?.title = "Курс валют"
            let tabItem = UITabBarItem(title: "Курс валют",
            image: R.image.exchangesDeselected(),
            selectedImage: R.image.exchangesSelected())
            navigationController.tabBarItem = tabItem
            
        case .graph:
            let graphViewController = GraphViewController(nib: R.nib.graphViewController)
            navigationController = AppNavigationController(rootViewController: graphViewController)
            navigationController.navigationBar.topItem?.title = "Графики"
            let tabItem = UITabBarItem(title: "Графики",
            image: R.image.graphDeselected(),
            selectedImage: R.image.graphSelected())
            navigationController.tabBarItem = tabItem
            
        case .settings:
            let settingsViewController = SettingsViewController(nib: R.nib.settingsViewController)
            navigationController = AppNavigationController(rootViewController: settingsViewController)
            navigationController.navigationBar.topItem?.title = "Настройки"
            let tabItem = UITabBarItem(title: "Настройки",
            image: R.image.settingsDeselected(),
            selectedImage: R.image.settingsSelected())
            navigationController.tabBarItem = tabItem
        }
        
        return navigationController
    }
}

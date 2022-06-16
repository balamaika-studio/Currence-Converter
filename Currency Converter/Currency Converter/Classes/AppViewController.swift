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
    case exchangeRates
    case graph
    case settings
    
    var viewController: UIViewController {
        var navigationController = AppNavigationController()
        switch self {
        case .converter:
            let converterViewController = ConverterViewController(nib: R.nib.converterViewController)
            navigationController = AppNavigationController(rootViewController: converterViewController)
            navigationController.navigationBar.topItem?.title = R.string.localizable.converterTitle()
            
            let tabItem = UITabBarItem(title: R.string.localizable.converterTabBarItem(),
                         image: R.image.converterDeselected(),
                         selectedImage: R.image.converterDeselected())
            navigationController.tabBarItem = tabItem
            
        case .exchangeRates:
            let exchangeRatesViewController = ExchangeRatesViewController(nib: R.nib.exchangeRatesViewController)
            navigationController = AppNavigationController(rootViewController: exchangeRatesViewController)
            navigationController.navigationBar.topItem?.title = R.string.localizable.exchangesTitle()
            
            let tabItem = UITabBarItem(title: R.string.localizable.exchangesTabBarItem(),
            image: R.image.exchangesDeselected(),
            selectedImage: R.image.exchangesDeselected())
            navigationController.tabBarItem = tabItem
            
        case .graph:
            let graphViewController = GraphViewController(nib: R.nib.graphViewController)
            navigationController = AppNavigationController(rootViewController: graphViewController)
            navigationController.navigationBar.topItem?.title = R.string.localizable.graphTitle()
            
            let tabItem = UITabBarItem(title: R.string.localizable.graphTabBarItem(),
            image: R.image.graphDeselected(),
            selectedImage: R.image.graphDeselected())
            navigationController.tabBarItem = tabItem
            
        case .settings:
            let settingsViewController = SettingsViewController(nib: R.nib.settingsViewController)
            navigationController = AppNavigationController(rootViewController: settingsViewController)
            navigationController.navigationBar.topItem?.title = R.string.localizable.settingsTitle()
            
            let tabItem = UITabBarItem(title: R.string.localizable.settingsTabBarItem(),
            image: R.image.settingsDeselected(),
            selectedImage: R.image.settingsDeselected())
            navigationController.tabBarItem = tabItem
        }
        
        return navigationController
    }
}

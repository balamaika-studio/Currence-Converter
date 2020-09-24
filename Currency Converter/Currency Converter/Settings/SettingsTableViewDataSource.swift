//
//  SettingsTableViewDataSource.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/23/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit
import StoreKit

class SettingsTableViewDataSource: NSObject {
    var products: [SKProduct] = []
    
    private func autoUpdate(_ state: Bool) {
        UserDefaults.standard.set(state, forKey: "autoUpdate")
    }
    
    private func clearField(_ state: Bool) {
        AppFieldClearManager.shared.isClear = state
        UserDefaults.standard.set(state, forKey: "clearField")
    }
    
    private func updateTheme(_ state: Bool) {        
        let newTheme = state == true ? AppTheme.dark : AppTheme.light
        AppThemeManager.shared.currentTheme = newTheme
    }
}

extension SettingsTableViewDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingsSection(rawValue: section) else { return 0 }
        switch section {
        case .network: return NetworkOptions.allCases.count
        case .appearance: return AppearanceOptions.allCases.count
        case .purchases:
            let availableProducts = products.filter { !ConverterProducts.store.isProductPurchased($0.productIdentifier) }
            return availableProducts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        guard let section = SettingsSection(rawValue: indexPath.section) else {
            return cell
        }
        
        switch section {
        case .network:
            guard let settingCell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.cellId,
                                                                  for: indexPath) as? SettingsTableViewCell else { break }
            let network = NetworkOptions(rawValue: indexPath.row)
            settingCell.sectionType = network
            settingCell.autoUpdateChanged = self.autoUpdate
            cell.selectionStyle = .none
            let isAutoUpdateEnable = UserDefaults.standard.bool(forKey: "autoUpdate")
            settingCell.switchState = SwitchState(rawValue: isAutoUpdateEnable)
            cell = settingCell
            
        case .purchases:
            let purchaseCellId = R.reuseIdentifier.settingsPurchaseCell
            guard let purchaseCell = tableView.dequeueReusableCell(withIdentifier: purchaseCellId,
                                                                   for: indexPath) else { break }
            purchaseCell.product = products[indexPath.row]
            purchaseCell.buyButtonHandler = { product in
                ConverterProducts.store.buyProduct(product)
            }
            cell = purchaseCell
            
        case .appearance:
            guard
                let settingCell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.cellId,
                                                                for: indexPath) as? SettingsTableViewCell,
                let appearance = AppearanceOptions(rawValue: indexPath.row) else { break }
            settingCell.sectionType = appearance
            switch appearance {
            case .clearField:
                settingCell.clearFieldChnaged = self.clearField
                cell.selectionStyle = .none
                let isFieldClearEnable = AppFieldClearManager.shared.isClear
                settingCell.switchState = SwitchState(rawValue: isFieldClearEnable)
                
            case .accuracy:
                let accuracy = Accuracy(rawValue: AccuracyManager.shared.accuracy)
                cell.detailTextLabel?.text = accuracy?.description
                
            case .theme:
                let switchState = AppThemeManager.shared.currentTheme == .dark ? true : false
                settingCell.themeChanged = self.updateTheme
                settingCell.selectionStyle = .none
                settingCell.switchState = SwitchState(rawValue: switchState)
            }
            cell = settingCell
        }
        
        return cell
    }
}

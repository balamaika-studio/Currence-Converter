//
//  SettingsTableViewDataSource.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/23/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

class SettingsTableViewDataSource: NSObject {
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
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = SettingsTableViewCell.cellId
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId,
                                                     for: indexPath) as? SettingsTableViewCell,
            let section = SettingsSection(rawValue: indexPath.section) else {
                return UITableViewCell()
        }
        
        switch section {
        case .network:
            let network = NetworkOptions(rawValue: indexPath.row)
            cell.sectionType = network
            cell.autoUpdateChanged = self.autoUpdate
            cell.selectionStyle = .none
            let isAutoUpdateEnable = UserDefaults.standard.bool(forKey: "autoUpdate")
            cell.switchState = SwitchState(rawValue: isAutoUpdateEnable)
            
        case .appearance:
            guard let appearance = AppearanceOptions(rawValue: indexPath.row) else { break }
            cell.sectionType = appearance
            switch appearance {
            case .clearField:
                cell.clearFieldChnaged = self.clearField
                cell.selectionStyle = .none
                let isFieldClearEnable = AppFieldClearManager.shared.isClear
                cell.switchState = SwitchState(rawValue: isFieldClearEnable)
                
            case .accuracy:
                let accuracy = Accuracy(rawValue: AccuracyManager.shared.accurancy)
                cell.detailTextLabel?.text = accuracy?.description
                
            case .theme:
                let switchState = AppThemeManager.shared.currentTheme == .dark ? true : false
                cell.themeChanged = self.updateTheme
                cell.selectionStyle = .none
                cell.switchState = SwitchState(rawValue: switchState)
            }
        }
        
        return cell
    }
}

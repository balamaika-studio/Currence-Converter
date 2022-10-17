//
//  SettingsTableViewCell.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/21/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    static let cellId = "SettingsTableViewCell"
    
    var autoUpdateChanged: ((Bool) -> Void)?
    var clearFieldChnaged: ((Bool) -> Void)?
    var themeChanged: ((Bool) -> Void)?
    
    var switchState: SwitchState? {
        didSet {
            guard let state = switchState else { return }
            switchControl.isOn = state.rawValue
            handleSwitchAction(sender: switchControl)
        }
    }
    
    var sectionType: SectionCellType? {
        didSet {
            guard let sectionType = sectionType else { return }
            textLabel?.text = sectionType.description
            detailTextLabel?.text = sectionType.detailText
            switchControl.isHidden = !sectionType.containsSwitch
        }
    }
    
    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.onTintColor = #colorLiteral(red: 0.3647058824, green: 0.5647058824, blue: 0.9921568627, alpha: 1)
        switchControl.addTarget(self,
                                action: #selector(handleSwitchAction(sender:)),
                                for: .valueChanged)
        switchControl.isOn = false
        return switchControl
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(switchControl)
        NSLayoutConstraint.activate([
            switchControl.centerYAnchor.constraint(equalTo: centerYAnchor),
            trailingAnchor.constraint(equalTo: switchControl.trailingAnchor, constant: 16)
        ])
        // 3.75% of cell width
        let size = bounds.width * 0.0375
        detailTextLabel?.font = UIFont.systemFont(ofSize: size)
        textLabel?.font = UIFont.systemFont(ofSize: 16)
        setUpTheming()

    }

    @objc private func handleSwitchAction(sender: UISwitch) {
        var result = String()
        let switchState = SwitchState(rawValue: sender.isOn)
        guard let switchText = switchState?.description else { return }
        
        if let network = sectionType as? NetworkOptions {
            result = "\(network) \(switchText)"
            autoUpdateChanged?(sender.isOn)
        } else if let appearanceOptions = sectionType as? AppearanceOptions {
            result = switchText.capitalized
            switch appearanceOptions {
            case .clearField: clearFieldChnaged?(sender.isOn)
            case .theme: themeChanged?(sender.isOn)
                
            default: break
            }
        }
        
        detailTextLabel?.text = result
    }
    
}

extension SettingsTableViewCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        textLabel?.textColor = theme.textColor
        detailTextLabel?.textColor = theme.subtitleColor
        backgroundColor = theme.backgroundColor
    }
}

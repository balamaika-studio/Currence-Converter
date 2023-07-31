//
//  SettingsTableViewCell.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/21/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol SettingsTableViewCellDelegate: AnyObject {
    func autoUpdateTapped()
}

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var underlineView: UIView!
    @IBOutlet private weak var switchControl: UISwitch!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var titleLable: UILabel!
    
    var autoUpdateChanged: ((Bool) -> Void)?
    var clearFieldChnaged: ((Bool) -> Void)?
    var themeChanged: ((Bool) -> Void)?
    weak var delegate: SettingsTableViewCellDelegate?
    
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
            titleLable.text = sectionType.description
            switchControl.isHidden = !sectionType.containsSwitch
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        setUpTheming()
    }
    
    func configure(with type: SectionCellType?, state: SwitchState?, position: SettingsPosition) {
        if let type {
            sectionType = type
            titleLable.text = type.description
            switchControl.isHidden = !type.containsSwitch
        }

        if let state {
            switchControl.isHidden = false
            switchControl.isOn = state.rawValue
            handleSwitchAction(sender: switchControl)
        } else {
            switchControl.isHidden = true
        }
        
        configureForPosition(position)
    }
    
    func setDelegate(_ delegate: SettingsTableViewCellDelegate?) {
        self.delegate = delegate
    }
    
    override func prepareForReuse() {
        mainView.roundCorners(corners: [.allCorners], radius: 0)
    }
    
    // MARK: - Private Methods
    private func setupView() {
        backgroundColor = .clear
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.onTintColor = #colorLiteral(red: 0.1921568627, green: 0.3960784314, blue: 0.9843137255, alpha: 1)
        switchControl.addTarget(self,
                                action: #selector(handleSwitchAction(sender:)),
                                for: .valueChanged)
        switchControl.isOn = false
    }
    
    private func configureForPosition(_ position: SettingsPosition) {
        switch position {
        case .first:
            mainView.roundCorners(corners: [.topRight, .topLeft], radius: 10)
            underlineView.isHidden = false
        case .middle:
            mainView.roundCorners(corners: [.allCorners], radius: 0)
            underlineView.isHidden = false
        case .last:
            mainView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
            underlineView.isHidden = true
        case .all:
            mainView.roundCorners(corners: [.allCorners], radius: 10)
            underlineView.isHidden = true
        }
    }

    @objc private func handleSwitchAction(sender: UISwitch) {
        let switchState = SwitchState(rawValue: sender.isOn)
        guard let switchText = switchState?.description else { return }
        
        if sectionType is NetworkOptions {
            autoUpdateChanged?(sender.isOn)
            if sender.isOn {
                delegate?.autoUpdateTapped()
            }
        } else if let appearanceOptions = sectionType as? AppearanceOptions {
            switch appearanceOptions {
            case .clearField: clearFieldChnaged?(sender.isOn)
            case .theme: themeChanged?(sender.isOn)
            }
        }
    }
    
}

extension SettingsTableViewCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        if theme.themeId == "light" {
            mainView.backgroundColor = .white
            titleLable.textColor = .black
        } else {
            titleLable.textColor = .white
            mainView.backgroundColor = #colorLiteral(red: 0.3294117647, green: 0.3294117647, blue: 0.3450980392, alpha: 0.65)
        }
        
//        textLabel?.textColor = theme.textColor
//        detailTextLabel?.textColor = theme.subtitleColor
//        backgroundColor = theme.backgroundColor
    }
}

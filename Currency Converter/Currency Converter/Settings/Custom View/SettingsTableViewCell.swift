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
        switchControl.isOn = true
        switchControl.addTarget(self,
                                action: #selector(handleSwitchAction(sender:)),
                                for: .valueChanged)
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
        addSubview(switchControl)
        NSLayoutConstraint.activate([
            switchControl.centerYAnchor.constraint(equalTo: centerYAnchor),
            trailingAnchor.constraint(equalTo: switchControl.trailingAnchor, constant: 16)
        ])
        detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        detailTextLabel?.textColor = .gray
        textLabel?.font = UIFont.systemFont(ofSize: 16)
    }

    @objc private func handleSwitchAction(sender: UISwitch) {
        var result = String()
        let testEnum = TestEnum(rawValue: sender.isOn)
        guard let test = testEnum?.description else { return }
        
        if let network = sectionType as? NetworkOptions {
            result = "\(network) \(test)"
            autoUpdateChanged?(sender.isOn)
        } else if let _ = sectionType as? AppearanceOptions {
            result = test.capitalized
            clearFieldChnaged?(sender.isOn)
        }
        detailTextLabel?.text = result
    }
}

enum TestEnum {
    case on
    case off
}

extension TestEnum: RawRepresentable {
    typealias RawValue = Bool
    
    var rawValue: RawValue {
        switch self {
        case .on: return true
        case .off: return false
        }
    }
    
    init?(rawValue: RawValue) {
        self = rawValue == true ? .on : .off
    }
}

extension TestEnum: CustomStringConvertible {
    var description: String {
        switch self {
        case .on: return "включено"
        case .off: return "отключено"
        }
    }
}

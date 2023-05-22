//
//  SettingsTableViewHeader.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/21/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

class SettingsTableViewHeader: UITableViewHeaderFooterView {
    static let reuseId = "sectionHeader"
    
    private lazy var headerTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with section: SettingsSection) {
        headerTitleLabel.text = section.description
    }
    
    // MARK: - Private Methods
    private func setupView() {
        contentView.backgroundColor = .white
        contentView.addSubview(headerTitleLabel)
        NSLayoutConstraint.activate([
            headerTitleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            headerTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        setUpTheming()
    }
    
}

extension SettingsTableViewHeader: Themed {
    func applyTheme(_ theme: AppTheme) {
        headerTitleLabel.textColor = theme.cancelTitleColor
        contentView.backgroundColor = .clear
    }
}

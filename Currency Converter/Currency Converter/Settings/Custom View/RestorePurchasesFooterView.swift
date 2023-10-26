//
//  RestorePurchasesFooterView.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 9/15/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

class RestorePurchasesFooterView: UITableViewHeaderFooterView {
    static let reuseId = "restorePurchasesFooterView"
    
    private lazy var restoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(R.string.localizable.restorePurchases(), for: .normal)
        button.contentEdgeInsets = .init(top: 8, left: 12, bottom: 8, right: 12)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(restoreTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var termsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0
        label.text = R.string.localizable.bottomTextSettings()
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func restoreTapped() {
        ConverterProducts.store.restorePurchases()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        contentView.addSubview(restoreButton)
        NSLayoutConstraint.activate([
            restoreButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            restoreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        contentView.addSubview(termsLabel)
        NSLayoutConstraint.activate([
            termsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            termsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            termsLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            termsLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16)
        ])
        
        setUpTheming()
    }
    
}

extension RestorePurchasesFooterView: Themed {
    func applyTheme(_ theme: AppTheme) {
        termsLabel.textColor = theme.cancelTitleColor
        restoreButton.backgroundColor = .clear
        restoreButton.setTitleColor(theme.segmentedControlTintColor, for: .normal)
        contentView.backgroundColor = .clear
        restoreButton.layer.cornerRadius = restoreButton.frame.height / 10
    }
}

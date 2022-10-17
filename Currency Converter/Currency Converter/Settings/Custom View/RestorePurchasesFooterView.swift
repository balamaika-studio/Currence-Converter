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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(restoreTapped), for: .touchUpInside)
        return button
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
            restoreButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        restoreButton.layer.borderWidth = 0.5
        setUpTheming()
    }
    
}

extension RestorePurchasesFooterView: Themed {
    func applyTheme(_ theme: AppTheme) {
        restoreButton.backgroundColor = theme.purchaseButtonColor
        restoreButton.setTitleColor(theme.textColor, for: .normal)
        restoreButton.layer.borderColor = theme.restoreBorderColor.cgColor
        contentView.backgroundColor = theme.backgroundColor
        restoreButton.layer.cornerRadius = restoreButton.frame.height / 10
    }
}

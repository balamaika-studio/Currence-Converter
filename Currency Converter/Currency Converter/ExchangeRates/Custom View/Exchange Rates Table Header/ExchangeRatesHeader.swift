//
//  ExchangeRatesHeader.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/10/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

class ExchangeRatesHeader: UITableViewHeaderFooterView {
    static let reuseId = "sectionHeader"
    
    private lazy var pairsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = R.string.localizable.availablePairs()
        return label
    }()
    
    private let rateLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = R.string.localizable.rate()
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
        setUpTheming()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hideRateLabel() {
        rateLabel.isHidden = true
    }
    
    func changePairsLabel() {
        pairsLabel.text = R.string.localizable.pairs()
    }
    
    private func configureContents() {
        contentView.addSubview(pairsLabel)
        contentView.addSubview(rateLabel)

        NSLayoutConstraint.activate([
            pairsLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            pairsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            rateLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            rateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
}

extension ExchangeRatesHeader: Themed {
    func applyTheme(_ theme: AppTheme) {
        contentView.backgroundColor = theme.backgroundColor
        rateLabel.textColor = theme.textColor
        pairsLabel.textColor = theme.textColor
    }
}

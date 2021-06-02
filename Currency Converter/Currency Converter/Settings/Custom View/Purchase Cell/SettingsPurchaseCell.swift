//
//  SettingsPurchaseCell.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 9/15/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit
import StoreKit


class SettingsPurchaseCell: UITableViewCell {
    static let cellId = "SettingsPurchaseCell"
    private let contentSpace: CGFloat = 8
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    
    var buyButtonHandler: ((_ product: SKProduct) -> Void)?
    var product: SKProduct?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpTheming()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func butButtonTapped(_ sender: Any) {
        guard let product = product else { return }
        buyButtonHandler?(product)
    }
    
    private func setupView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentSpace),
            trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: contentSpace),
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: contentSpace),
            bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: contentSpace),
        ])
        
        titleLabel.text = R.string.localizable.adsTitle()
        buyButton.setTitle(R.string.localizable.removeAds(), for: .normal)
        selectionStyle = .none
        contentView.layer.cornerRadius = contentView.frame.height / 10
        buyButton.layer.cornerRadius = buyButton.frame.height / 10
    }
}

extension SettingsPurchaseCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        titleLabel.textColor = .white
        buyButton.setTitleColor(theme.textColor, for: .normal)
        buyButton.backgroundColor = theme.purchaseButtonColor
        contentView.backgroundColor = theme.purchaseCellColor
        backgroundColor = theme.specificBackgroundColor
    }
}

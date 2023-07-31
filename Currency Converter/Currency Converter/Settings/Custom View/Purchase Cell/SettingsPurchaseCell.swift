//
//  SettingsPurchaseCell.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 9/15/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit
import StoreKit

protocol SettingsPurchaseCellDelegate {
    func buyButtonTapped()
}


class SettingsPurchaseCell: UITableViewCell {
    static let cellId = "SettingsPurchaseCell"
    private let contentSpace: CGFloat = 8
    private var delegate: SettingsPurchaseCellDelegate?
    
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpTheming()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func butButtonTapped(_ sender: Any) {
        delegate?.buyButtonTapped()
    }
    
    public func setDelegate(delagate: SettingsPurchaseCellDelegate?) {
        self.delegate = delagate
    }
    
    private func setupView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentSpace),
            trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: contentSpace),
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: contentSpace),
            bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: contentSpace),
        ])
        
        title.text = R.string.localizable.adsTitle()
//        subtitle.text = R.string.localizable.adsSubtitle()
        buyButton.setTitle(R.string.localizable.removeAds(), for: .normal)
        selectionStyle = .none
        contentView.layer.cornerRadius = contentView.frame.height / 10
        buyButton.layer.cornerRadius = buyButton.frame.height / 10
    }
}

extension SettingsPurchaseCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        title.textColor = .white
        subtitle.textColor = .white
        buyButton.setTitleColor(.white, for: .normal)
//        buyButton.backgroundColor = theme.purchaseButtonColor
//        contentView.backgroundColor = theme.settingsBackgroundColor
        backgroundColor = .clear
    }
}

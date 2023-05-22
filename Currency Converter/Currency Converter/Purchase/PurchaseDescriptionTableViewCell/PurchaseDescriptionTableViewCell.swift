//
//  PurchaseDescriptionTableViewCell.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/17/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

class PurchaseDescriptionTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var mainBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpTheming()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let theme = themeProvider.currentTheme

    }
    
    func configure(model: PurchaseDescriptionModel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subTitle
    }
    
}
extension PurchaseDescriptionTableViewCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        mainBackgroundView.backgroundColor = .clear
        titleLabel.textColor = theme.textColor
        subtitleLabel.textColor = theme.subtitleColor
    }
}

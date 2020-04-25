//
//  ConverterCurrencyTableViewCell.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/16/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

class ConverterCurrencyTableViewCell: UITableViewCell {
    @IBOutlet weak var swapCurrencyIcon: UIImageView!
    @IBOutlet weak var currencyImageView: UIImageView!
    @IBOutlet weak var currencyAbbreviationLabel: UILabel!
    @IBOutlet weak var currencyTitleLabel: UILabel!
    @IBOutlet weak var currencyRateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpTheming()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with viewModel: FavoriteConverterViewModel) {
        let image = UIImage(named: viewModel.currency.lowercased())
        currencyImageView.image = image
        currencyAbbreviationLabel.text = viewModel.currency
        currencyTitleLabel.text = viewModel.title
        currencyRateLabel.text = viewModel.regardingRate
        selectionStyle = .none
    }
}

extension ConverterCurrencyTableViewCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        let swapCurrencyIconImage = theme == .light ?
        R.image.swapCurrencyLight() :
        R.image.swapCurrencyDark()
        currencyAbbreviationLabel.textColor = theme.textColor
        currencyTitleLabel.textColor = theme.subtitleColor
        currencyRateLabel.textColor = theme.textColor
        swapCurrencyIcon.image = swapCurrencyIconImage
    }
}

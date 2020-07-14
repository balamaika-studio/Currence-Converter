//
//  ChoiceCurrencyTableViewCell.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/17/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

class ChoiceCurrencyTableViewCell: UITableViewCell {
    @IBOutlet weak var currencyImageView: UIImageView!
    @IBOutlet weak var currencyAbbreviationLabel: UILabel!
    @IBOutlet weak var currencyTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpTheming()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let theme = themeProvider.currentTheme
        let selectColor = selected ?
            theme.tableCellSelectionColor :
            theme.specificBackgroundColor
        contentView.backgroundColor = selectColor
    }
    
    func configure(with viewModel: ChoiceCurrencyViewModel) {
        let emptyFlag = R.image.emptyFlag()
        let image = UIImage(named: viewModel.currency.lowercased()) ?? emptyFlag
        currencyImageView.image = image
        currencyAbbreviationLabel.text = viewModel.currency
        currencyTitleLabel.text = viewModel.title
        selectionStyle = .none
    }
    
}
extension ChoiceCurrencyTableViewCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        backgroundColor = theme.specificBackgroundColor
        currencyAbbreviationLabel.textColor = theme.textColor
        currencyTitleLabel.textColor = theme.subtitleColor
    }
}

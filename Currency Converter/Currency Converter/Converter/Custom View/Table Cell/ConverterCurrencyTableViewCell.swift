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
    
    /// get reoder control image view
    var reorderControlImageView: UIImageView? {
        let reorderControl = self.subviews.first {
            $0.classForCoder.description() == "UITableViewCellReorderControl"
        }
        return reorderControl?.subviews.first { $0 is UIImageView } as? UIImageView
    }
    
    private var myReorderImage: UIImage? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpTheming()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        // Change reorder control image color
        guard let imageView = reorderControlImageView else { return }
        if myReorderImage == nil {
            let reorderImage = imageView.image
            myReorderImage = reorderImage?.withRenderingMode(.alwaysTemplate)
        }
        imageView.image = myReorderImage
        imageView.tintColor = themeProvider.currentTheme.textColor
    }
    
    func configure(with viewModel: FavoriteConverterViewModel) {
        let emptyFlag = R.image.emptyFlag()
        let image = UIImage(named: viewModel.currency.lowercased()) ?? emptyFlag
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
        reorderControlImageView?.tint(color: theme.textColor)
    }
}

extension UIImageView {
    func tint(color: UIColor) {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}

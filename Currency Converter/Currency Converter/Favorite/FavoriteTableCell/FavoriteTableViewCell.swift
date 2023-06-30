//
//  FavoriteTableViewCell.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/26/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    @IBOutlet weak var currencyImageView: UIImageView!
    @IBOutlet weak var currencyAbbreviationLabel: UILabel!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var currencyTitleLabel: UILabel!
    @IBOutlet weak var selectionView: UIView!
    
    private var selectionColor: UIColor!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpTheming()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionView.backgroundColor = selected ? selectionColor : nil
        checkBoxImageView.image = selected ? R.image.boxOn() : R.image.boxOff()
    }
    
    func configure(with viewModel: FavoriteViewModel) {
        let emptyFlag = R.image.emptyFlag()
        let image = UIImage(named: viewModel.currency.lowercased()) ?? emptyFlag
        currencyImageView.image = image
        currencyImageView.roundCorners(corners: [.allCorners], radius: 10)
        currencyAbbreviationLabel.text = viewModel.currency
        currencyTitleLabel.text = viewModel.title
        selectionStyle = .none
    }
}

extension FavoriteTableViewCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionColor = .clear
        currencyAbbreviationLabel.textColor = theme.textColor
        currencyTitleLabel.textColor = theme.subtitleColor
    }
}

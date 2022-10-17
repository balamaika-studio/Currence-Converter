//
//  CurrencyPairTableViewCell.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/9/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

class CurrencyPairTableViewCell: UITableViewCell {

    @IBOutlet private weak var leftFlagImageView: UIImageView!
    @IBOutlet private weak var leftCurrencyLabel: UILabel!
    @IBOutlet private weak var rightCurrencyLAbel: UILabel!
    @IBOutlet private weak var rightFlagImageView: UIImageView!
    @IBOutlet private weak var changeImageView: UIImageView!
    @IBOutlet private weak var rateLabel: UILabel!
    @IBOutlet private weak var selectionView: UIView!
    
    private var selectionColor: UIColor!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpTheming()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        selectionView.backgroundColor = selected ? selectionColor : nil
    }
    
    func configure(with viewModel: CurrencyPairViewModel) {
        var changeImage: UIImage = UIImage()
        switch viewModel.change {
        case .increase:
            changeImage = UIImage(named: "ic_arroy_up")!

        case .down:
            changeImage = UIImage(named: "ic_arroy_down")!

        case .stay:
            changeImage = UIImage(named: "ic_stay")!

        }
        let emptyFlag = R.image.emptyFlag()
        let imageLeft = UIImage(named: viewModel.leftCurrency.lowercased()) ?? emptyFlag
        let imageRight = UIImage(named: viewModel.rightCurrency.lowercased()) ?? emptyFlag
        leftFlagImageView.image = imageLeft
        rightFlagImageView.image = imageRight
        leftCurrencyLabel.text = viewModel.leftCurrency
        rightCurrencyLAbel.text = viewModel.rightCurrency
        changeImageView.image = changeImage
        rateLabel.text = viewModel.rate
        rateLabel.textColor = rateColor(change: viewModel.change)
        selectionStyle = .none
    }

    override func layoutSubviews() {
        selectionView.layer.cornerRadius = 10

        selectionView.clipsToBounds = true
        selectionView.layer.masksToBounds = false
        selectionView.layer.shadowRadius = 7
        selectionView.layer.shadowOpacity = 0.6
        selectionView.layer.shadowOffset = CGSize(width: 0, height: 5)
        selectionView.layer.shadowColor = UIColor(red: 0.192, green: 0.396, blue: 0.984, alpha: 0.2).cgColor
        selectionView.layer.borderWidth = 1.5
    }
//
//    func configureForSelection() {
//        changeImageView.isHidden = true
//        rateLabel.isHidden = true
//    }
    
    private func rateColor(change: Change) -> UIColor {
        var color: UIColor
        switch change {
        case .down: color = #colorLiteral(red: 0.8705882353, green: 0.08235294118, blue: 0.08235294118, alpha: 1)
        case .increase: color = #colorLiteral(red: 0.01176470588, green: 0.6745098039, blue: 0.262745098, alpha: 1)
        case .stay: color = #colorLiteral(red: 0.2023873329, green: 0.2353575826, blue: 0.3237472773, alpha: 1)
        }
        return color
    }
}

extension CurrencyPairTableViewCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        backgroundColor = .clear
        contentView.backgroundColor = theme.backgroundColor
        leftCurrencyLabel.textColor = theme.textColor
        rightCurrencyLAbel.textColor = theme.textColor
        selectionView.backgroundColor = theme.backgroundColor
        selectionView.layer.borderColor = UIColor.white.cgColor
    }
}

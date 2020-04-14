//
//  CurrencyPairTableViewCell.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/9/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

class CurrencyPairTableViewCell: UITableViewCell {
    @IBOutlet weak var currencyRelativeLabel: UILabel!
    @IBOutlet weak var changeImageView: UIImageView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var selectionView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let color = #colorLiteral(red: 0.7019608021, green: 0.8431372643, blue: 1, alpha: 1)
        selectionView.backgroundColor = selected ? color : nil
    }
    
    func configure(with viewModel: CurrencyPairViewModel) {
        let changeImage = UIImage(named: viewModel.change.rawValue)
        currencyRelativeLabel.text = viewModel.relation
        changeImageView.image = changeImage
        rateLabel.text = "\(viewModel.rate)"
        selectionStyle = .none
    }
    
    func configureForSelection() {
        changeImageView.isHidden = true
        rateLabel.isHidden = true
    }
}

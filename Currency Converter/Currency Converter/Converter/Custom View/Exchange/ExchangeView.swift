//
//  ExchangeView.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/16/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit
@IBDesignable
class ExchangeView: UIView {
    // MARK: - UI
    @IBOutlet weak var flagImageViw: UIImageView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var changeCurrencyStack: UIStackView!
    
    // MARK: - Properties
    let tapGesture = UITapGestureRecognizer()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
        setup()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    // MARK: - Private Methods
    private func loadViewFromNib() {
        let view = R.nib.exchangeView(owner: self)!
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setup() {
        tapGesture.addTarget(self, action: #selector(changeCurrencyTapped))
        changeCurrencyStack.addGestureRecognizer(tapGesture)
    }
    
    @objc private func changeCurrencyTapped() {
        print("Chnage Currency Tapped!")
    }
}

//
//  ExchangeView.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/16/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol ExchangeViewDeleagte: class {
    func changeCurrencyTapped(exchangeView view: ExchangeView)
    func convert(exchangeView sender: ExchangeView, total: Double)
}

@IBDesignable
class ExchangeView: UIView {
    // MARK: - UI
    @IBOutlet weak var flagImageViw: UIImageView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var changeCurrencyStack: UIStackView!
    @IBOutlet weak var countTextField: UITextField!
    
    // MARK: - Properties
    private let tapGesture = UITapGestureRecognizer()
    weak var delegate: ExchangeViewDeleagte?
    
    // TODO: Replace with Model Currency
    var currencyName: String {
        return currencyLabel.text ?? "N/A"
    }
    
    var rate: Double!
    
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
    
    func configure(with currency: ExchangeCurrency) {
        flagImageViw.image = UIImage(named: currency.currency.lowercased())
        currencyLabel.text = currency.currency
        rateLabel.text = currency.regardingRate
        rate = currency.rate
    }

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
        countTextField.delegate = self
        tapGesture.addTarget(self, action: #selector(changeCurrencyTapped))
        changeCurrencyStack.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func textFieldEditingDidChange(_ sender: UITextField) {
        let a = Double(sender.text ?? "0") ?? 0
        delegate?.convert(exchangeView: self, total: a)
    }
    
    
    @objc private func changeCurrencyTapped() {
        delegate?.changeCurrencyTapped(exchangeView: self)
    }
}

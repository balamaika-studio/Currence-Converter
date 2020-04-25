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
    @IBOutlet weak var changeCurrencyIcon: UIImageView!
    @IBOutlet weak var flagImageViw: UIImageView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var changeCurrencyStack: UIStackView!
    @IBOutlet weak var countTextField: UITextField!
    
    // MARK: - Properties
    private var contentView: UIView!
    private let tapGesture = UITapGestureRecognizer()
    weak var delegate: ExchangeViewDeleagte?
    
    var currencyName: String {
        return viewModel.currency
    }
        
    var viewModel: ExchangeCurrency!
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        setup()
        setUpTheming()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
        setup()
        setUpTheming()
    }
    
    deinit {
        AppFieldClearManager.shared.detach(self)
    }
    
    func configure(with currency: ExchangeCurrency) {
        flagImageViw.image = UIImage(named: currency.currency.lowercased())
        currencyLabel.text = currency.currency
        rateLabel.text = currency.regardingRate
        viewModel = currency
    }

    // MARK: - Private Methods
    private func loadViewFromNib() {
        let view = R.nib.exchangeView(owner: self)!
        contentView = view
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
        setUpClearSetting()
    }
    
    @IBAction func textFieldEditingDidChange(_ sender: UITextField) {
        let total = Double(sender.text ?? "0") ?? 0
        delegate?.convert(exchangeView: self, total: total)
    }
    
    @objc private func changeCurrencyTapped() {
        delegate?.changeCurrencyTapped(exchangeView: self)
    }
}

extension ExchangeView: FieldClearable {
    func update(with subject: AppFieldClearManager) {
        countTextField.clearsOnBeginEditing = subject.isClear
    }
}

extension ExchangeView: Themed {
    func applyTheme(_ theme: AppTheme) {
        let changeCurrencyIconImage = theme == .light ?
            R.image.changeCurrencyLight() :
            R.image.changeCurrencyDark()
        contentView.backgroundColor = theme.backgroundConverterColor
        currencyLabel.textColor = theme.textColor
        rateLabel.textColor = theme.subtitleColor
        countTextField.textColor = theme.textColor
        changeCurrencyIcon.image = changeCurrencyIconImage
    }
}

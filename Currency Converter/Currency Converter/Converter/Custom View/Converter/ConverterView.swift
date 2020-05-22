//
//  ConverterView.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/16/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

class ConverterView: UIView {
    // MARK: - UI
    @IBOutlet weak var swapCurrencyButton: UIButton!
    @IBOutlet weak var updatedLabel: UILabel!
    @IBOutlet weak var topCurrency: ExchangeView!
    @IBOutlet weak var bottomCurrency: ExchangeView!
    @IBOutlet weak var topSeparator: UIView!
    @IBOutlet weak var bottomSeparator: UIView!
    
    // MARK: - Properties
    var changeCurrencyTapped: ((ExchangeView) -> Void)?
    var swapCurrencyTapped: ((Currency) -> Void)?
    var topCurrencyTotal: ((Double) -> Void)?
    var replacingView: ExchangeView!
    
    private var contentView: UIView!
    
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
    
    // MARK: - Actions
    @IBAction func swapCurrencyTapped(_ sender: UIButton) {
        let model = ConverterViewModel(firstExchange: bottomCurrency.viewModel,
                                       secondExchange: topCurrency.viewModel,
                                       updated: updatedLabel.text!)
        updateWith(model)
        swapCurrencyTapped?(topCurrency.viewModel)
    }

    // MARK: - Private Methods
    private func loadViewFromNib() {
        let view = R.nib.converterView(owner: self)!
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
        topCurrency.delegate = self
        bottomCurrency.delegate = self
    }
    
    func updateWith(_ viewModel: ConverterViewModel) {
        configureConverterCurrencies(viewModel)
        let total = topCurrency.total
        convert(exchangeView: topCurrency, total: total)
    }
    
    private func configureConverterCurrencies(_ viewModel: ConverterViewModel) {
        topCurrency.configure(with: viewModel.firstExchange)
        bottomCurrency.configure(with: viewModel.secondExchange)
        updatedLabel.text = viewModel.updated
    }
}

extension ConverterView: ExchangeViewDeleagte {
    func convert(exchangeView sender: ExchangeView, total: Double) {
        let converterResult = AccuracyManager.shared.formatNumber(total * sender.viewModel.exchangeRate)
        let activeCurrency = topCurrency.isEqual(sender) ? bottomCurrency : topCurrency
        activeCurrency?.countTextField.text = "\(converterResult)"
        topCurrencyTotal?(topCurrency.total)
    }
    
    func changeCurrencyTapped(exchangeView view: ExchangeView) {
        replacingView = view
        changeCurrencyTapped?(view)
    }
}


extension ConverterView: Themed {
    func applyTheme(_ theme: AppTheme) {
        updatedLabel.textColor = theme.subtitleColor
        contentView.backgroundColor = theme.backgroundConverterColor
        topSeparator.backgroundColor = theme.separatorColor
        bottomSeparator.backgroundColor = theme.separatorColor
    }
}

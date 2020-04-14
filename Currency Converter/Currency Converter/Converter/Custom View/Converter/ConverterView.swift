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
    
    // MARK: - Properties
    var changeCurrencyTapped: ((ExchangeView) -> Void)?
    var swapCurrencyTapped: ((Currency) -> Void)?
    var replacingView: ExchangeView!
    
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
    
    // MARK: - Actions
    @IBAction func swapCurrencyTapped(_ sender: UIButton) {
        let model = ConverterViewModel(firstExchange: bottomCurrency.viewModel,
                                       secondExchange: topCurrency.viewModel,
                                       updated: updatedLabel.text!)
        
        let tmpTopCount = topCurrency.countTextField.text
        topCurrency.countTextField.text = bottomCurrency.countTextField.text
        bottomCurrency.countTextField.text = tmpTopCount
        configureConverterCurrencies(model)
        swapCurrencyTapped?(topCurrency.viewModel)
    }

    // MARK: - Private Methods
    private func loadViewFromNib() {
        let view = R.nib.converterView(owner: self)!
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
    
    func justUpdate(_ viewModel: ConverterViewModel) {
        configureConverterCurrencies(viewModel)
        let total = Double(topCurrency.countTextField.text ?? "0") ?? 0
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
        // TODO: Calculation accuracy
        let converterResult = round(total * sender.viewModel.exchangeRate * pow(10, 4)) / pow(10, 4)
        let activeCurrency = topCurrency.isEqual(sender) ? bottomCurrency : topCurrency
        activeCurrency?.countTextField.text = "\(converterResult)"
    }
    
    func changeCurrencyTapped(exchangeView view: ExchangeView) {
        replacingView = view
        changeCurrencyTapped?(view)
    }
}

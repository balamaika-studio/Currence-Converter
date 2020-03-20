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
    var didTap: (() -> Void)?
    var replacingView: ExchangeView?
    
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
        print("Swap Tapped!")
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
        topCurrency.configure(with: viewModel.firstExchange)
        bottomCurrency.configure(with: viewModel.secondExchange)
    }
    
    private func updateConverterCurrency(with currency: Currency) {
//        replacingView?.configure(with: currency)
    }
}

extension ConverterView: ExchangeViewDeleagte {
    func changeCurrencyTapped(exchangeView view: ExchangeView) {
        replacingView = view
        didTap?()
    }
}

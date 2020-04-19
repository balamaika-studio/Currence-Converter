//
//  RelativeExchangeView.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/17/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

class RelativeExchangeView: UIView {
    // MARK: - UI
    @IBOutlet weak var baseCurrencyImageView: UIImageView!
    @IBOutlet weak var baseCurrencyLabel: UILabel!
    @IBOutlet weak var baseCurrencyTitleLabel: UILabel!
    @IBOutlet weak var baseChangeCurrencyStack: UIStackView!
    
    @IBOutlet weak var relativeCurrencyImageView: UIImageView!
    @IBOutlet weak var relativeCurrencyLabel: UILabel!
    @IBOutlet weak var relativeCurrencyTitleLabel: UILabel!
    @IBOutlet weak var relativeChangeCurrencyStack: UIStackView!
    
    @IBOutlet weak var swapCurrenciesWidth: NSLayoutConstraint!
    
    //MARK: - Properties
    var baseCurrency: ChoiceCurrencyViewModel!
    var relativeCurrency: ChoiceCurrencyViewModel!
    var selectedCurrency: ChoiceCurrencyViewModel!
    var changeCurrencyTapped: (() -> Void)?
    var updateCurrenciesLabel: ((String) -> Void)?
    
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
    @IBAction func swapCurrenciesTapped(_ sender: UIButton) {
        let tmpCurrency = baseCurrency
        baseCurrency = relativeCurrency
        relativeCurrency = tmpCurrency
        setupView()
    }
    
    // MARK: - Methods
    override func layoutSubviews() {
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shadowRadius = 5
        layer.shadowOffset = .init(width: 0, height: 5)
        layer.shadowOpacity = 0.1
    }
    
    func configure(with viewModel: GraphConverterViewModel) {
        baseCurrency = viewModel.base
        relativeCurrency = viewModel.relative
        setupView()
    }
    
    func updateSelectedCurrency(with model: ChoiceCurrencyViewModel) {
        if selectedCurrency == baseCurrency {
            baseCurrency = model
        } else {
            relativeCurrency = model
        }
        setupView()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        baseCurrencyImageView.image = UIImage(named: baseCurrency.currency.lowercased())
        baseCurrencyLabel.text = baseCurrency.currency
        baseCurrencyTitleLabel.text = baseCurrency.title
        
        relativeCurrencyImageView.image = UIImage(named: relativeCurrency.currency.lowercased())
        relativeCurrencyLabel.text = relativeCurrency.currency
        relativeCurrencyTitleLabel.text = relativeCurrency.title
        
        updateCurrenciesLabel?(buildCurrenciesRateLabelText())
    }
    
    private func loadViewFromNib() {
        let view = R.nib.relativeExchangeView(owner: self)!
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
        baseChangeCurrencyStack.addGestureRecognizer(setGestureRecognizer())
        baseChangeCurrencyStack.accessibilityIdentifier = "base"
        relativeChangeCurrencyStack.addGestureRecognizer(setGestureRecognizer())
        relativeChangeCurrencyStack.accessibilityIdentifier = "relative"
    }
    
    private func buildCurrenciesRateLabelText() -> String {
        var result = "..."
        guard
            let baseText = baseCurrencyLabel.text,
            let relativetext = relativeCurrencyLabel.text else {
                return result
        }
        result = "1\(baseText) = x\(relativetext)"
        return result
    }
    
    private func setGestureRecognizer() -> UITapGestureRecognizer {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(changeCurrencyTapped(_:)))
        return tapGesture
    }
    
    @objc private func changeCurrencyTapped(_ recognizer: UITapGestureRecognizer) {
        guard let viewId = recognizer.view?.accessibilityIdentifier else { return }
        switch viewId {
        case "base": selectedCurrency = baseCurrency
        case "relative": selectedCurrency = relativeCurrency
        default:
            print("Unknown view ID")
        }
        changeCurrencyTapped?()
    }
}

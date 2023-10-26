//
//  RelativeExchangeView.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/17/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit
import Appodeal
import Firebase

class RelativeExchangeView: UIView {
    // MARK: - UI
    @IBOutlet weak var baseCurrencyImageView: UIImageView!
    @IBOutlet weak var baseCurrencyLabel: UILabel!
    @IBOutlet weak var baseChangeCurrencyStack: UIStackView!
    @IBOutlet weak var baseBackgroundView: UIView!
    
    @IBOutlet weak var relativeBackgroundView: UIView!
    @IBOutlet weak var relativeCurrencyImageView: UIImageView!
    @IBOutlet weak var relativeCurrencyLabel: UILabel!
    @IBOutlet weak var relativeChangeCurrencyStack: UIStackView!

    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var switchBackgroundView: UIView!
    @IBOutlet weak var shadowContainerView: UIView!

    private var contentView: UIView!
    
    //MARK: - Properties
    var baseCurrency: ChoiceCurrencyViewModel!
    var relativeCurrency: ChoiceCurrencyViewModel!
    var selectedCurrency: ChoiceCurrencyViewModel!
    var changeCurrencyTapped: ((Bool, String) -> Void)?
    var updateCurrenciesLabel: ((String) -> Void)?
    
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
    @IBAction func swapCurrenciesTapped(_ sender: UIButton) {
        Appodeal.trackEvent("Graphs_currency", customParameters: ["Graphs_currency": "click"])
        Analytics.logEvent("Graphs_currency", parameters: ["Graphs_currency": "click"])
        let tmpCurrency = baseCurrency
        baseCurrency = relativeCurrency
        relativeCurrency = tmpCurrency
        setupView()
    }
    
    // MARK: - Methods
    override func layoutSubviews() {
        switchBackgroundView.layer.cornerRadius = 14

        switchBackgroundView.clipsToBounds = true
        switchBackgroundView.layer.masksToBounds = false
        switchBackgroundView.layer.shadowRadius = 7
        switchBackgroundView.layer.shadowOpacity = 0.6
        switchBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 5)
        switchBackgroundView.layer.shadowColor = UIColor(red: 0.192, green: 0.396, blue: 0.984, alpha: 0.2).cgColor
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
        let emptyFlag = R.image.emptyFlag()
        baseCurrencyImageView.image = UIImage(named: baseCurrency.currency.lowercased()) ?? emptyFlag
        baseCurrencyLabel.text = baseCurrency.currency
        baseBackgroundView.layer.cornerRadius = 14
        relativeBackgroundView.layer.cornerRadius = 14
        
        relativeCurrencyImageView.image = UIImage(named: relativeCurrency.currency.lowercased()) ?? emptyFlag
        relativeCurrencyLabel.text = relativeCurrency.currency
        
        updateCurrenciesLabel?(buildCurrenciesRateLabelText())
    }
    
    private func loadViewFromNib() {
        let view = R.nib.relativeExchangeView(owner: self)!
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
        result = "\(baseText) \(R.string.localizable.forVal()) 1\(relativetext)"
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
        case "base":
            selectedCurrency = baseCurrency
            changeCurrencyTapped?(true, relativeCurrency.currency)
        case "relative":
            selectedCurrency = relativeCurrency
            changeCurrencyTapped?(false, baseCurrency.currency)
        default:
            print("Unknown view ID")
        }

    }
}


extension RelativeExchangeView: Themed {
    func applyTheme(_ theme: AppTheme) {
        contentView.backgroundColor = theme.backgroundColor
        backgroundColor = theme.backgroundColor
        baseCurrencyLabel.textColor = theme.textColor
        baseBackgroundView.backgroundColor = theme == .light ? #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 0.15) : #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        relativeBackgroundView.backgroundColor = theme == .light ? #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 0.15) : #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        switchBackgroundView.backgroundColor = theme == .light ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.2450228035, green: 0.4974169135, blue: 0.9887898564, alpha: 1)
        if theme == .light {
            switchButton.setImage(R.image.rotatedSwap()!, for: .normal)
        } else {
            switchButton.setImage(R.image.rotatedSwapDark()!, for: .normal)
        }
//        baseCurrencyTitleLabel.textColor = theme.subtitleColor
        
        relativeCurrencyLabel.textColor = theme.textColor
//        relativeCurrencyTitleLabel.textColor = theme.subtitleColor
//        shadowContainerView.backgroundColor = theme.backgroundColor
//        shadowContainerView.layer.borderColor = UIColor.white.cgColor
    }
}

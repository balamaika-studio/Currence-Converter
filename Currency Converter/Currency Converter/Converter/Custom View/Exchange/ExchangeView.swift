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
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var countTextField: UITextField!
    
    // MARK: - Properties
    private var contentView: UIView!
    private let tapGesture = UITapGestureRecognizer()
    private let maxLength = 8
    weak var delegate: ExchangeViewDeleagte?
    
    var currencyName: String {
        return viewModel.currency
    }
    
    var total: Double {
        return Double(countTextField.text ?? "0") ?? 0
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
        let emptyFlag = R.image.emptyFlag()
        flagImageView.image = UIImage(named: currency.currency.lowercased()) ?? emptyFlag
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
        tapGesture.delegate = self
        tapGesture.addTarget(self, action: #selector(changeCurrencyTapped))
        contentView.addGestureRecognizer(tapGesture)
        countTextField.delegate = self
        addDoneButtonOnKeyboard()
        setUpClearSetting()
    }
    
    private func addDoneButtonOnKeyboard(){
        let width = UIScreen.main.bounds.width
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: R.string.localizable.done(),
                                                    style: .done,
                                                    target: self,
                                                    action: #selector(self.doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        countTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        countTextField.resignFirstResponder()
    }
    
    @IBAction func textFieldEditingDidChange(_ sender: UITextField) {
        delegate?.convert(exchangeView: self, total: total)
    }
    
    @objc private func changeCurrencyTapped() {
        delegate?.changeCurrencyTapped(exchangeView: self)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ExchangeView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: contentView)
        if point.x >= countTextField.frame.minX {
           return false
        }
        return true
    }
}

// MARK: - UITextFieldDelegate
extension ExchangeView: UITextFieldDelegate {
    // textfiled max length
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""
        
        if string == "," {
            textField.text = currentText + "."
            return false
        }
        
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // remove symbol tapped
        if updatedText.count < currentText.count { return true }
        // make sure the result is under max length
        return updatedText.count <= maxLength
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}

// MARK: - FieldClearable
extension ExchangeView: FieldClearable {
    func update(with subject: AppFieldClearManager) {
        countTextField.clearsOnBeginEditing = subject.isClear
    }
}

// MARK: - Themed
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

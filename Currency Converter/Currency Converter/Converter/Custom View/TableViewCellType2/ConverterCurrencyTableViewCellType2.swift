//
//  ConverterCurrencyTableViewCell.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/16/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol ConverterCurrencyTableViewCellType2Deleagte: class {
    func changeCurrencyTapped(exchangeView view: UITableViewCell)
    func convert(exchangeView sender: UITableViewCell, total: Double)
}

class ConverterCurrencyTableViewCellType2: UITableViewCell {
    @IBOutlet private weak var currencyImageView: UIImageView!
    @IBOutlet private weak var currencyAbbreviationLabel: UILabel!
    @IBOutlet private weak var currencyTitleLabel: UILabel!
    @IBOutlet private weak var countTextField: UITextField!
    @IBOutlet private weak var mainView: UIView!

    private let maxLength = 8
    private var validateService: Validating?
    weak var delegate: ConverterCurrencyTableViewCellType2Deleagte?

    var total: Double {
        return Double(countTextField.text ?? "0") ?? 0
    }
    
    /// get reoder control image view
    var reorderControlImageView: UIImageView? {
        let reorderControl = self.subviews.first {
            $0.classForCoder.description() == "UITableViewCellReorderControl"
        }
        return reorderControl?.subviews.first { $0 is UIImageView } as? UIImageView
    }
    
    private var myReorderImage: UIImage? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpTheming()
        setup()
    }

    private func setup() {
        countTextField.delegate = self
        validateService = ValidateService()
        countTextField.addAccessoryViewWithDoneButton()
        setUpClearSetting()
        countTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        delegate?.convert(exchangeView: self, total: total)
    }

    override func layoutSubviews() {
        mainView.layer.cornerRadius = 10

        mainView.clipsToBounds = true
        mainView.layer.masksToBounds = false
        mainView.layer.shadowRadius = 7
        mainView.layer.shadowOpacity = 0.6
        mainView.layer.shadowOffset = CGSize(width: 0, height: 5)
        mainView.layer.shadowColor = UIColor(red: 0.192, green: 0.396, blue: 0.984, alpha: 0.2).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        // Change reorder control image color
        guard let imageView = reorderControlImageView else { return }
        if myReorderImage == nil {
            let reorderImage = imageView.image
            myReorderImage = reorderImage?.withRenderingMode(.alwaysTemplate)
        }
        imageView.image = myReorderImage
        imageView.tintColor = themeProvider.currentTheme.textColor
    }
    
    func configure(with viewModel: FavoriteConverterViewModel) {
        let emptyFlag = R.image.emptyFlag()
        let image = UIImage(named: viewModel.currency.lowercased()) ?? emptyFlag
        currencyImageView.image = image
        currencyAbbreviationLabel.text = viewModel.currency
        currencyTitleLabel.text = viewModel.title
        countTextField.text = viewModel.total
        selectionStyle = .none
    }
}

extension ConverterCurrencyTableViewCellType2: Themed {
    func applyTheme(_ theme: AppTheme) {
        currencyAbbreviationLabel.textColor = theme.textColor
        currencyTitleLabel.textColor = theme.subtitleColor
        countTextField.textColor = theme.textColor
        reorderControlImageView?.tint(color: theme.textColor)
    }
}

extension UIImageView {
    func tint(color: UIColor) {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}

// MARK: - UITextFieldDelegate
extension ConverterCurrencyTableViewCellType2: UITextFieldDelegate {
    // textfiled max length
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // checks data validity
        let validateResult = ValidateService().isConverterFieldCorrect(text: string)
        if !validateResult { return false }

        // only one point supported
        if currentText.contains(".") && string == "," { return false }

        // prohibits the entry of zeros before a number
        if (currentText.hasPrefix("0") && string != ",") && string != "" {
            return currentText.hasPrefix("0.")
        }

        // replace comma with point
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
extension ConverterCurrencyTableViewCellType2: FieldClearable {
    func update(with subject: AppFieldClearManager) {
        countTextField.clearsOnBeginEditing = subject.isClear
    }
}

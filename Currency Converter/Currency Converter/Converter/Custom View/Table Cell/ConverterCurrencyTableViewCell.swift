//
//  ConverterCurrencyTableViewCell.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/16/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ConverterCurrencyTableViewCell: BaseTableCell {
    
    @IBOutlet private weak var currencyImageView: UIImageView!
    @IBOutlet private weak var currencyAbbreviationLabel: UILabel!
    @IBOutlet private weak var currencyTitleLabel: UILabel!
    //@IBOutlet weak var currencyRateLabel: UILabel!
    @IBOutlet private weak var countTextField: UITextField!
    @IBOutlet private weak var mainView: UIView!

    var onChangeValue: ((Double)->Void)?
    
    var value: Double {
        return Double(countTextField.text ?? "0") ?? 0
    }
    
    //override var cellHeight: CGFloat? { 60 }
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setup()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setup()
//    }
//
//    private func setup() {
//
//        setUpTheming()
//    }
    
//    /// get reoder control image view
//    var reorderControlImageView: UIImageView? {
//        let reorderControl = self.subviews.first {
//            $0.classForCoder.description() == "UITableViewCellReorderControl"
//        }
//        return reorderControl?.subviews.first { $0 is UIImageView } as? UIImageView
//    }
    
    //private var myReorderImage: UIImage? = nil
    private let maxLength = 8

//    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: animated)
//        // Change reorder control image color
//        guard let imageView = reorderControlImageView else { return }
//        if myReorderImage == nil {
//            let reorderImage = imageView.image
//            myReorderImage = reorderImage?.withRenderingMode(.alwaysTemplate)
//        }
//        imageView.image = myReorderImage
//        imageView.tintColor = themeProvider.currentTheme.textColor
//    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onChangeValue = nil
    }
    
    override func setupUI() {
        super.setupUI()
        bgView.backgroundColor = .clear
        let content = R.nib.converterCellContentView(owner: self)!
        containerView.addSubview(content)
        content.ec.edges.constraintsToSuperview(with: .zero)
        containerView.backgroundColor = .clear
        setUpTheming()
        separatorColor = .clear
        separatorHeight = 0
        mainView.layer.cornerRadius = 10

        mainView.clipsToBounds = true
        mainView.layer.masksToBounds = false
        mainView.layer.shadowRadius = 7
        mainView.layer.shadowOpacity = 0.6
        mainView.layer.shadowOffset = CGSize(width: 0, height: 5)
        mainView.layer.shadowColor = UIColor(red: 0.192, green: 0.396, blue: 0.984, alpha: 0.2).cgColor
    }
    
    func configure<T: ConverterCellModelProtocol>(with viewModel: T) {
        let emptyFlag = R.image.emptyFlag()
        let image = UIImage(named: viewModel.currencyCode.lowercased()) ?? emptyFlag
        currencyImageView.image = image
        currencyAbbreviationLabel.text = viewModel.currencyCode
        currencyTitleLabel.text = viewModel.currencyName
        countTextField.text = viewModel.formattedCount
        countTextField.addAccessoryViewWithDoneButton()
        //currencyRateLabel.text = viewModel.total
        selectionStyle = .none
    }
    
    @IBAction private func textFieldEditingDidChange(_ sender: UITextField) {
        //delegate?.convert(exchangeView: self, total: total)
        onChangeValue?(value)
    }
}

extension ConverterCurrencyTableViewCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        //currencyAbbreviationLabel.textColor = theme.textColor
        //currencyTitleLabel.textColor = theme.subtitleColor
        //currencyRateLabel.textColor = theme.textColor
        //reorderControlImageView?.tint(color: theme.textColor)
    }
}

extension UIImageView {
    func tint(color: UIColor) {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}

// MARK: - UITextFieldDelegate
extension ConverterCurrencyTableViewCell: UITextFieldDelegate {
    // textfiled max length
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""
        
        // checks data validity
        let validateResult = Validator.isConverterFieldCorrect(text: string)
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

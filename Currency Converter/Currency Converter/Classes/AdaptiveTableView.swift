//
//  AdaptiveTableView.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 6/22/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

class AdaptiveTableView: TableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
         NotificationCenter.default.addObserver(self,
                                                selector: #selector(keyboardDidShow(_:)),
                                                name: UIResponder.keyboardDidShowNotification,
                                                object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        let defaultInset = AdBannerInsetService.shared.tableInset
        adjustContentInsets(defaultInset)
    }
    
    
    @objc private func keyboardDidShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
        }
        let keyboardSize = frame.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0,
                                         bottom: keyboardSize.height, right: 0.0)
        adjustContentInsets(contentInsets)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        let defaultInset = AdBannerInsetService.shared.tableInset
        adjustContentInsets(defaultInset)
    }
    
    private func adjustContentInsets(_ contentInsets: UIEdgeInsets) {
        contentInset = contentInsets
        scrollIndicatorInsets = contentInsets
    }
}

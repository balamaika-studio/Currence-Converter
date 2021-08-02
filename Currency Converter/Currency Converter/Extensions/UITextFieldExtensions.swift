//
//  UITextFieldExtensions.swift
//  Currency Converter
//
//  Created by Александр Томашевский on 03.08.2021.
//  Copyright © 2021 Kiryl Klimiankou. All rights reserved.
//

import UIKit

extension UITextField {
    
    func addAccessoryViewWithDoneButton() {
        let width = UIScreen.main.bounds.width
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: R.string.localizable.done(),
                                                    style: .done,
                                                    target: self,
                                                    action: #selector(onDone))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        inputAccessoryView = doneToolbar
    }
    
    @objc private func onDone() {
        resignFirstResponder()
    }
}

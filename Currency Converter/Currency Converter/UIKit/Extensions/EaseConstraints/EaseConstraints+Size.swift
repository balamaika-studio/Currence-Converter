//
//  EaseConstraints+Size.swift
//  Currency Converter
//
//  Created by Александр Томашевский on 15.08.2021.
//  Copyright © 2021 Kiryl Klimiankou. All rights reserved.
//

import UIKit

extension UIView.EaseConstraints {
    
    struct Size {
        let owner: UIView
    }
    
    var size: Size { .init(owner: view) }
}

extension UIView.EaseConstraints.Size {
    
    func constraint(height: CGFloat) {
        owner.translatesAutoresizingMaskIntoConstraints = false
        owner.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func constraint(width: CGFloat) {
        owner.translatesAutoresizingMaskIntoConstraints = false
        owner.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func constraint(size: CGSize) {
        constraint(height: size.height)
        constraint(width: size.width)
    }
    
    func constraintHeight(equalTo view: UIView, multipler: CGFloat = 1) {
        owner.translatesAutoresizingMaskIntoConstraints = false
        owner.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multipler).isActive = true
    }
    
    func constraintWidth(equalTo view: UIView, multipler: CGFloat = 1) {
        owner.translatesAutoresizingMaskIntoConstraints = false
        owner.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multipler).isActive = true
    }
}

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
    
    @discardableResult
    func constraint(height: CGFloat) -> UIView.EaseConstraints.Constraint {
        owner.translatesAutoresizingMaskIntoConstraints = false
        let c = owner.heightAnchor.constraint(equalToConstant: height)
        c.isActive = true
        return .init(constraint: c)
    }
    
    @discardableResult
    func constraint(width: CGFloat) -> UIView.EaseConstraints.Constraint {
        owner.translatesAutoresizingMaskIntoConstraints = false
        let c = owner.widthAnchor.constraint(equalToConstant: width)
        c.isActive = true
        return .init(constraint: c)
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

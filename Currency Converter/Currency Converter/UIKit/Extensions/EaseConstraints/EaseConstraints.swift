//
//  EaseConstraints.swift
//  Currency Converter
//
//  Created by Александр Томашевский on 15.08.2021.
//  Copyright © 2021 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol ConstraintFactory {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: ConstraintFactory { }

extension UILayoutGuide: ConstraintFactory { }

extension UIView {
    
    struct EaseConstraints {
        let view: UIView
    }
}

extension UIView.EaseConstraints {
    
    enum ConstraintTarget {
        case view(UIView)
        case layoutGuide(UILayoutGuide)
    }
}

extension UIView.EaseConstraints.ConstraintTarget {
    
    var factory: ConstraintFactory {
        switch self {
        case .view(let view): return view
        case .layoutGuide(let guide): return guide
        }
    }
}

extension UIView {
    
    var ec: EaseConstraints { .init(view: self) }
}

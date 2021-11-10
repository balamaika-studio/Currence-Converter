//
//  EaseConstraints+UIEdgesInsets.swift
//  Currency Converter
//
//  Created by Александр Томашевский on 15.08.2021.
//  Copyright © 2021 Kiryl Klimiankou. All rights reserved.
//

import UIKit

extension UIView.EaseConstraints {
    
    struct Edges {
        
        let owner: UIView
    }
}

extension UIView.EaseConstraints.Edges {
        
    func constraints(to target: UIView.EaseConstraints.ConstraintTarget, with insets: UIEdgeInsets) {
        owner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            owner.topAnchor.constraint(equalTo: target.factory.topAnchor, constant: insets.top),
            owner.bottomAnchor.constraint(equalTo: target.factory.bottomAnchor, constant: -insets.bottom),
            owner.leadingAnchor.constraint(equalTo: target.factory.leadingAnchor, constant: insets.left),
            owner.trailingAnchor.constraint(equalTo: target.factory.trailingAnchor, constant: -insets.right)
        ])
    }
    
    func constraintsToSuperview(with insets: UIEdgeInsets) {
        guard let superview = owner.superview else { fatalError() }
        constraints(to: .view(superview), with: insets)
    }
    
    func constraintsToSuperviewSafeArea(with insets: UIEdgeInsets) {
        guard let guide = owner.superview?.safeAreaLayoutGuide else { fatalError() }
        constraints(to: .layoutGuide(guide), with: insets)
    }
}

extension UIView.EaseConstraints {
    
    var edges: Edges { Edges(owner: view) }
}

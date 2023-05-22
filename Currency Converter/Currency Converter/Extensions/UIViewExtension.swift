//
//  UIViewExtension.swift
//  Currency Converter
//
//  Created by Vlad Sys on 17.04.23.
//  Copyright © 2023 Kiryl Klimiankou. All rights reserved.
//

import UIKit

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

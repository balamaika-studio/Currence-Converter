//
//  CALayer+RoundCorners.swift
//
//  Created by Александр Томашевский on 06.08.2021.
//

import UIKit

extension CALayer {
    
    enum RoundCornersMode {
        case topCorners, bottomCorners, allCorners
    }
    
    func roundCorners(with mode: RoundCornersMode, radius: CGFloat, masksToBounds: Bool = true) {
        self.masksToBounds = masksToBounds
        cornerRadius = radius
        switch mode {
        case .allCorners:
            maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .topCorners:
            maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .bottomCorners:
            maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
}

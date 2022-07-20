//
//  UISegmentControlExtension.swift
//  Currency Converter
//
//  Created by Vlad Sys on 20.07.22.
//  Copyright © 2022 Kiryl Klimiankou. All rights reserved.
//

import Foundation
import UIKit

extension UISegmentedControl {
    func setClearBackgroundSegmentControl() {
        if #available(iOS 13.0, *) {
            //just to be sure it is full loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                for i in 0...(self.numberOfSegments - 1)  {
                    let backgroundSegmentView = self.subviews[i]
                    //it is not enogh changing the background color. It has some kind of shadow layer
                    backgroundSegmentView.isHidden = true
                }
            }
        }
    }
}

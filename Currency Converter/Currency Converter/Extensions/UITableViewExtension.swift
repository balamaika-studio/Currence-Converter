//
//  UITableViewExtension.swift
//  Currency Converter
//
//  Created by Vlad Sys on 16.06.22.
//  Copyright © 2022 Kiryl Klimiankou. All rights reserved.
//

import UIKit

extension UITableView {
    /// Iterates over all subviews of a `UITableView` instance and applies the supplied font to all labels withing the UISwipeAction's array.
    /// - Parameter font: The font that should be applied to the labels.
    /// - Parameter tintColor: The tint color that should be applied to image views and labels
    /// - Parameter ignoreFirst: Whether or not the first swipe action should be ignored when applying tints
    public func setSwipeActionFont(_ font: UIFont, withTintColor tintColor: UIColor? = nil, andIgnoreFirst ignoreFirst: Bool = false) {
        for subview in self.subviews {
            //Confirm that the view being touched is within a swipe container
            guard NSStringFromClass(type(of: subview)) == "_UITableViewCellSwipeContainerView" else {
                continue
            }

            //Re-iterate subviews and confirm that we are touching a swipe view
            for swipeContainerSubview in subview.subviews {
                guard NSStringFromClass(type(of: swipeContainerSubview)) == "UISwipeActionPullView" else {
                    continue
                }

                //Enumerate subviews and confirm that we are touching a button
                for (index, view) in swipeContainerSubview.subviews.filter({ $0 is UIButton }).enumerated() {
                    //Set Font
                    guard let button = view as? UIButton else {
                        continue
                    }
                    button.titleLabel?.font = font

                    //Set Tint Conditionally (based on index)
                    guard index > 0 || !ignoreFirst else {
                        continue
                    }
                    button.setTitleColor(tintColor, for: .normal)
                    button.imageView?.tintColor = tintColor
                }
            }
        }
    }
    
    public func isValid(indexPath: IndexPath) -> Bool {
        return indexPath.section >= 0
        && indexPath.section < self.numberOfSections
        && indexPath.row >= 0
        && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}

//
//  NavBarExtension.swift
//  Currency Converter
//
//  Created by Vlad Sys on 5.10.22.
//  Copyright © 2022 Kiryl Klimiankou. All rights reserved.
//

import UIKit

extension UINavigationBar {
  func update(backroundColor: UIColor? = nil, titleColor: UIColor? = nil) {
    if #available(iOS 15, *) {
      let appearance = UINavigationBarAppearance()
      appearance.configureWithTransparentBackground()
      if let backroundColor = backroundColor {
        appearance.backgroundColor = backroundColor
      }
      if let titleColor = titleColor {
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor]
      }
      standardAppearance = appearance
      scrollEdgeAppearance = appearance
    } else {
      barStyle = .blackTranslucent
      if let backroundColor = backroundColor {
        barTintColor = backroundColor
      }
      if let titleColor = titleColor {
        titleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor]
      }
    }
  }
}

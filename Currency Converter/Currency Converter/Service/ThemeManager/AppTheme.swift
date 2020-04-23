//
//  AppTheme.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/23/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

struct AppTheme {
    var statusBarStyle: UIStatusBarStyle
    var barBackgroundColor: UIColor
    var barForegroundColor: UIColor
    
    var backgroundColor: UIColor
    var backgroundConverterColor: UIColor
    
    var textColor: UIColor
    var subtitleColor: UIColor
}

extension AppTheme {
    static let light = AppTheme(
        statusBarStyle: .`default`,
        barBackgroundColor: #colorLiteral(red: 0.9764705882, green: 0.9843137255, blue: 1, alpha: 1),
        barForegroundColor: .black,
        backgroundColor: .white,
        backgroundConverterColor: .white,
        textColor: .darkText,
        subtitleColor: .gray
    )

    static let dark = AppTheme(
        statusBarStyle: .lightContent,
        barBackgroundColor: UIColor(white: 0, alpha: 1),
        barForegroundColor: .white,
        backgroundColor: UIColor(white: 0.2, alpha: 1),
        backgroundConverterColor: .green,
        textColor: .white,
        subtitleColor: .lightGray
    )
}

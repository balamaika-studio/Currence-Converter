//
//  AppTheme.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/23/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

struct AppTheme {
    let themeId: String
    var barBackgroundColor: UIColor
    
    var backgroundColor: UIColor
    var specificBackgroundColor: UIColor
    var backgroundConverterColor: UIColor
    
    var tableCellSelectionColor: UIColor
    var collectionCellSelectionColor: UIColor
    
    var textColor: UIColor
    var subtitleColor: UIColor
    var unselectedSwitchTextColor: UIColor
    
    var shadowOpacity: Float
    var searchTextColor: UIColor
}

extension AppTheme: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.themeId == rhs.themeId
    }
}

extension AppTheme {
    static let light = AppTheme(
        themeId: "light",
        barBackgroundColor: #colorLiteral(red: 0.9764705882, green: 0.9843137255, blue: 1, alpha: 1),
        
        backgroundColor: #colorLiteral(red: 0.9725490196, green: 0.9803921569, blue: 1, alpha: 1),
        specificBackgroundColor: .white,
        backgroundConverterColor: .white,
        
        tableCellSelectionColor: #colorLiteral(red: 0.9019607843, green: 0.9333333333, blue: 1, alpha: 1),
        collectionCellSelectionColor: #colorLiteral(red: 0.9019607843, green: 0.9333333333, blue: 1, alpha: 1),
        
        textColor: .darkText,
        subtitleColor: .gray,
        unselectedSwitchTextColor: .systemBlue,
        shadowOpacity: 0.3,
        searchTextColor: #colorLiteral(red: 0.4196078431, green: 0.4196078431, blue: 0.4196078431, alpha: 1)
    )

    static let dark = AppTheme(
        themeId: "dark",
        barBackgroundColor: #colorLiteral(red: 0.2235294118, green: 0.2078431373, blue: 0.3411764706, alpha: 1),
        
        backgroundColor: #colorLiteral(red: 0.1568627451, green: 0.1490196078, blue: 0.262745098, alpha: 1),
        specificBackgroundColor: #colorLiteral(red: 0.1568627451, green: 0.1490196078, blue: 0.262745098, alpha: 1),
        backgroundConverterColor: #colorLiteral(red: 0.2235294118, green: 0.2078431373, blue: 0.3411764706, alpha: 1),
        
        tableCellSelectionColor: #colorLiteral(red: 0.2156862745, green: 0.2196078431, blue: 0.337254902, alpha: 1),
        collectionCellSelectionColor: #colorLiteral(red: 0.2156862745, green: 0.2196078431, blue: 0.337254902, alpha: 1),
        
        textColor: .white,
        subtitleColor: .lightGray,
        unselectedSwitchTextColor: .white,
        shadowOpacity: 0.6,
        searchTextColor: #colorLiteral(red: 0.737254902, green: 0.737254902, blue: 0.8941176471, alpha: 1)
    )
}

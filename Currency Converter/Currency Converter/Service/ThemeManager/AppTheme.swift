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

    var barTintColor: UIColor
    var barUnselectedTintColor: UIColor
    var barBackgroundColor: UIColor
    var popUpBarColor: UIColor

    var backgroundColor: UIColor
    var settingsBackgroundColor: UIColor
    var specificBackgroundColor: UIColor
    var backgroundConverterColor: UIColor

    var tableCellSelectionColor: UIColor
    var collectionCellSelectionColor: UIColor

    var textColor: UIColor
    var subtitleColor: UIColor
    var priceColor: UIColor
    var unselectedSwitchTextColor: UIColor

    var cancelTitleColor: UIColor

    var shadowOpacity: Float
    var searchTextColor: UIColor
    var searchTextFieldColor: UIColor
    var segmentedControlTintColor: UIColor
    var separatorColor: UIColor

    var purchaseCellColor: UIColor
    var purchaseButtonColor: UIColor
    var restoreBorderColor: UIColor
}

extension AppTheme: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.themeId == rhs.themeId
    }
}

extension AppTheme {
    static let light = AppTheme(
        themeId: "light",
        barTintColor: UIColor(red: 0.19, green: 0.4, blue: 0.98, alpha: 1),
        barUnselectedTintColor: #colorLiteral(red: 0.3058823529, green: 0.2941176471, blue: 0.3764705882, alpha: 0.8),
        barBackgroundColor: #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 0.94),
        popUpBarColor: #colorLiteral(red: 0.1921568627, green: 0.3960784314, blue: 0.9843137255, alpha: 1),

        backgroundColor: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1),
        settingsBackgroundColor: UIColor(hexString: "#F0F3F5"), // fix
        specificBackgroundColor: .white,
        backgroundConverterColor: .white,

        tableCellSelectionColor: #colorLiteral(red: 0.9019607843, green: 0.9333333333, blue: 1, alpha: 1),
        collectionCellSelectionColor: #colorLiteral(red: 0.9019607843, green: 0.9333333333, blue: 1, alpha: 1),

        textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), // fix
        subtitleColor: #colorLiteral(red: 0.1529411765, green: 0.1764705882, blue: 0.2549019608, alpha: 0.4), // fix
        priceColor: #colorLiteral(red: 0.1529411765, green: 0.1764705882, blue: 0.2549019608, alpha: 1), // fix
        unselectedSwitchTextColor: .systemBlue,

        cancelTitleColor: #colorLiteral(red: 0.1529411765, green: 0.1764705882, blue: 0.2549019608, alpha: 0.4),

        shadowOpacity: 0.3,
        searchTextColor: #colorLiteral(red: 0.4196078431, green: 0.4196078431, blue: 0.4196078431, alpha: 1),
        searchTextFieldColor: #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9294117647, alpha: 1),
        segmentedControlTintColor: #colorLiteral(red: 0.4078431373, green: 0.4941176471, blue: 0.9960784314, alpha: 1),
        separatorColor: #colorLiteral(red: 0.8549019608, green: 0.8784313725, blue: 0.9294117647, alpha: 1),
        purchaseCellColor: #colorLiteral(red: 0.4156862745, green: 0.5529411765, blue: 0.9843137255, alpha: 1),
        purchaseButtonColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
        restoreBorderColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    )

    static let dark = AppTheme(
        themeId: "dark",
        barTintColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
        barUnselectedTintColor: #colorLiteral(red: 0.737254902, green: 0.737254902, blue: 0.8941176471, alpha: 1),
        barBackgroundColor: #colorLiteral(red: 0.0862745098, green: 0.0862745098, blue: 0.0862745098, alpha: 0.94),
        popUpBarColor: #colorLiteral(red: 0.2156862745, green: 0.2196078431, blue: 0.337254902, alpha: 1),

        backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
        settingsBackgroundColor:  #colorLiteral(red: 0.1529411765, green: 0.1607843137, blue: 0.2588235294, alpha: 1),
        specificBackgroundColor: #colorLiteral(red: 0.462745098, green: 0.462745098, blue: 0.5019607843, alpha: 0.24),
        backgroundConverterColor: #colorLiteral(red: 0.2156862745, green: 0.2196078431, blue: 0.337254902, alpha: 1),

        tableCellSelectionColor: #colorLiteral(red: 0.2156862745, green: 0.2196078431, blue: 0.337254902, alpha: 1),
        collectionCellSelectionColor: #colorLiteral(red: 0.2156862745, green: 0.2196078431, blue: 0.337254902, alpha: 1),

        textColor: .white, // fix
        subtitleColor: #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9607843137, alpha: 0.6), // fix
        priceColor: .white, // fix
        unselectedSwitchTextColor: .white,

        cancelTitleColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),

        shadowOpacity: 0.6,
        searchTextColor: #colorLiteral(red: 0.737254902, green: 0.737254902, blue: 0.8941176471, alpha: 1),
        searchTextFieldColor: #colorLiteral(red: 0.262745098, green: 0.2705882353, blue: 0.4392156863, alpha: 1),
        segmentedControlTintColor: #colorLiteral(red: 0.3803921569, green: 0.5176470588, blue: 1, alpha: 1),
        separatorColor: #colorLiteral(red: 0.3294117647, green: 0.3333333333, blue: 0.4784313725, alpha: 1),
        purchaseCellColor: #colorLiteral(red: 0.2156862745, green: 0.2196078431, blue: 0.337254902, alpha: 1),
        purchaseButtonColor: #colorLiteral(red: 0.4156862745, green: 0.5529411765, blue: 0.9843137255, alpha: 1),
        restoreBorderColor: #colorLiteral(red: 0.3882352941, green: 0.3882352941, blue: 0.4, alpha: 1)
    )
}

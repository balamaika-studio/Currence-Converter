//
//  AppThemeCodableExtension.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/25/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

extension AppTheme: Codable {
    enum CodingKeys: String, CodingKey {
        case themeId
        
        case barTintColor
        case barUnselectedTintColor
        case barBackgroundColor
        
        case backgroundColor
        case specificBackgroundColor
        case backgroundConverterColor
        
        case tableCellSelectionColor
        case collectionCellSelectionColor
        
        case textColor
        case subtitleColor
        case unselectedSwitchTextColor
        
        case shadowOpacity
        case searchTextColor
        case searchTextFieldColor
        case segmentedControlTintColor
        case separatorColor
        
        case purchaseCellColor
        case purchaseButtonColor
        case restoreBorderColor
    }
    
    // MARK: - Decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let themeId = try container.decode(String.self, forKey: .themeId)
        let shadowOpacity = try container.decode(Float.self, forKey: .shadowOpacity)
        
        self.themeId = themeId
        self.shadowOpacity = shadowOpacity
        
        barTintColor = try container.decode(CodableColor.self, forKey: .barTintColor).color
        barUnselectedTintColor = try container.decode(CodableColor.self,
                                                      forKey: .barUnselectedTintColor).color
        barBackgroundColor = try container.decode(CodableColor.self,
                                                  forKey: .barBackgroundColor).color
        
        backgroundColor = try container.decode(CodableColor.self, forKey: .backgroundColor).color
        specificBackgroundColor = try container.decode(CodableColor.self, forKey: .specificBackgroundColor).color
        backgroundConverterColor = try container.decode(CodableColor.self, forKey: .backgroundConverterColor).color
        
        tableCellSelectionColor = try container.decode(CodableColor.self, forKey: .tableCellSelectionColor).color
        collectionCellSelectionColor = try container.decode(CodableColor.self, forKey: .collectionCellSelectionColor).color
        
        textColor = try container.decode(CodableColor.self, forKey: .textColor).color
        subtitleColor = try container.decode(CodableColor.self, forKey: .subtitleColor).color
        unselectedSwitchTextColor = try container.decode(CodableColor.self, forKey: .unselectedSwitchTextColor).color
        
        searchTextColor = try container.decode(CodableColor.self, forKey: .searchTextColor).color
        searchTextFieldColor = try container.decode(CodableColor.self,
            forKey: .searchTextFieldColor).color
        segmentedControlTintColor = try container.decode(CodableColor.self,
            forKey: .segmentedControlTintColor).color
        separatorColor = try container.decode(CodableColor.self,
                                              forKey: .separatorColor).color
        
        purchaseCellColor = try container.decode(CodableColor.self, forKey: .purchaseCellColor).color
        purchaseButtonColor = try container.decode(CodableColor.self, forKey: .purchaseButtonColor).color
        restoreBorderColor = try container.decode(CodableColor.self, forKey: .restoreBorderColor).color
    }
    
    // MARK: - Encoder
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(themeId, forKey: .themeId)
        try container.encode(shadowOpacity, forKey: .shadowOpacity)
        
        try container.encode(CodableColor(color: barTintColor),
                             forKey: .barTintColor)
        try container.encode(CodableColor(color: barUnselectedTintColor),
                             forKey: .barUnselectedTintColor)
        try container.encode(CodableColor(color: barBackgroundColor),
                             forKey: .barBackgroundColor)
        
        try container.encode(CodableColor(color: backgroundColor),
                             forKey: .backgroundColor)
        try container.encode(CodableColor(color: specificBackgroundColor),
                             forKey: .specificBackgroundColor)
        try container.encode(CodableColor(color: backgroundConverterColor),
                             forKey: .backgroundConverterColor)
        
        try container.encode(CodableColor(color: tableCellSelectionColor),
                             forKey: .tableCellSelectionColor)
        try container.encode(CodableColor(color: collectionCellSelectionColor),
                             forKey: .collectionCellSelectionColor)
        
        try container.encode(CodableColor(color: textColor),
                             forKey: .textColor)
        try container.encode(CodableColor(color: subtitleColor),
                             forKey: .subtitleColor)
        try container.encode(CodableColor(color: unselectedSwitchTextColor),
                             forKey: .unselectedSwitchTextColor)
        
        try container.encode(CodableColor(color: searchTextColor),
                             forKey: .searchTextColor)
        try container.encode(CodableColor(color: searchTextFieldColor),
                             forKey: .searchTextFieldColor)
        try container.encode(CodableColor(color: segmentedControlTintColor),
                             forKey: .segmentedControlTintColor)
        try container.encode(CodableColor(color: separatorColor),
                             forKey: .separatorColor)
        
        try container.encode(CodableColor(color: purchaseCellColor),
                             forKey: .purchaseCellColor)
        try container.encode(CodableColor(color: purchaseButtonColor),
                             forKey: .purchaseButtonColor)
        try container.encode(CodableColor(color: restoreBorderColor),
                             forKey: .restoreBorderColor)
    }
}

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
    }
    
    // MARK: - Decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let themeId = try container.decode(String.self, forKey: .themeId)
        
        let barBackgroundColorData = try container.decode(Data.self,
                                                          forKey: .barBackgroundColor)
        let backgroundColorData = try container.decode(Data.self,
                                                          forKey: .backgroundColor)
        let specificBackgroundColorData = try container.decode(Data.self,
                                                               forKey: .specificBackgroundColor)
        let backgroundConverterColorData = try container.decode(Data.self,
                                                                forKey: .backgroundConverterColor)
        
        let tableCellSelectionColorData = try container.decode(Data.self,
                                                               forKey: .tableCellSelectionColor)
        let collectionCellSelectionColorData = try container.decode(Data.self,
                                                                    forKey: .collectionCellSelectionColor)
        
        let textColorData = try container.decode(Data.self,
                                             forKey: .textColor)
        let subtitleColorData = try container.decode(Data.self,
                                                 forKey: .subtitleColor)
        let unselectedSwitchTextColorData = try container.decode(Data.self,
                                                             forKey: .unselectedSwitchTextColor)
        
        let shadowOpacity = try container.decode(Float.self,
                                                 forKey: .shadowOpacity)
        let searchTextColorData = try container.decode(Data.self,
                                                   forKey: .searchTextColor)
        
        self.themeId = themeId
        
        barBackgroundColor = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(barBackgroundColorData) as? UIColor ?? UIColor.black
        backgroundColor = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(backgroundColorData) as? UIColor ?? UIColor.black
        specificBackgroundColor = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(specificBackgroundColorData) as? UIColor ?? UIColor.black
        backgroundConverterColor = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(backgroundConverterColorData) as? UIColor ?? UIColor.black
        
        tableCellSelectionColor = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(tableCellSelectionColorData) as? UIColor ?? UIColor.black
        collectionCellSelectionColor = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(collectionCellSelectionColorData) as? UIColor ?? UIColor.black
        
        textColor = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(textColorData) as? UIColor ?? UIColor.black
        subtitleColor = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(subtitleColorData) as? UIColor ?? UIColor.black
        unselectedSwitchTextColor = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unselectedSwitchTextColorData) as? UIColor ?? UIColor.black
        
        self.shadowOpacity = shadowOpacity
        searchTextColor = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(searchTextColorData) as? UIColor ?? UIColor.black
    }
    
    // MARK: - Encoder
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        let barBackgroundColorData = try NSKeyedArchiver.archivedData(withRootObject: barBackgroundColor, requiringSecureCoding: false)
        let backgroundColorData = try NSKeyedArchiver.archivedData(withRootObject: backgroundColor, requiringSecureCoding: false)
        let specificBackgroundColorData = try NSKeyedArchiver.archivedData(withRootObject: specificBackgroundColor, requiringSecureCoding: false)
        let backgroundConverterColorData = try NSKeyedArchiver.archivedData(withRootObject: backgroundConverterColor, requiringSecureCoding: false)
        
        let tableCellSelectionColorData = try NSKeyedArchiver.archivedData(withRootObject: tableCellSelectionColor, requiringSecureCoding: false)
        let collectionCellSelectionColorData = try NSKeyedArchiver.archivedData(withRootObject: collectionCellSelectionColor, requiringSecureCoding: false)
        
        let textColorData = try NSKeyedArchiver.archivedData(withRootObject: textColor, requiringSecureCoding: false)
        let subtitleColorData = try NSKeyedArchiver.archivedData(withRootObject: subtitleColor, requiringSecureCoding: false)
        let unselectedSwitchTextColorData = try NSKeyedArchiver.archivedData(withRootObject: unselectedSwitchTextColor, requiringSecureCoding: false)
        
        let searchTextColorData = try NSKeyedArchiver.archivedData(withRootObject: searchTextColor, requiringSecureCoding: false)
        
        
        try container.encode(themeId, forKey: .themeId)
        try container.encode(shadowOpacity, forKey: .shadowOpacity)
        
        
        try container.encode(barBackgroundColorData,
                             forKey: .barBackgroundColor)
        try container.encode(backgroundColorData,
                             forKey: .backgroundColor)
        try container.encode(specificBackgroundColorData,
                             forKey: .specificBackgroundColor)
        try container.encode(backgroundConverterColorData,
                             forKey: .backgroundConverterColor)
        
        try container.encode(tableCellSelectionColorData,
                             forKey: .tableCellSelectionColor)
        try container.encode(collectionCellSelectionColorData,
                             forKey: .collectionCellSelectionColor)
        
        try container.encode(textColorData, forKey: .textColor)
        try container.encode(subtitleColorData, forKey: .subtitleColor)
        try container.encode(unselectedSwitchTextColorData,
                             forKey: .unselectedSwitchTextColor)
        
        try container.encode(searchTextColorData, forKey: .searchTextColor)
        
    }
}

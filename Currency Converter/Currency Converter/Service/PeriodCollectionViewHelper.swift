//
//  PeriodCollectionViewHelper.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 5/6/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

class PeriodCollectionViewHelper {
    static var shared = PeriodCollectionViewHelper()
    
    private let defaultLineSpacing: CGFloat = 10
    private let defaultItemSpacing: CGFloat = 10
    private let defaultItemSize = CGSize(width: 50, height: 50)
    
    private init() {}
    
    func getLayout(for sizeClass: UIUserInterfaceSizeClass, itemsCount: Int, padding: CGFloat) -> UICollectionViewFlowLayout {
        let itemsCount = CGFloat(itemsCount)
        var cellSize = defaultItemSize
        var sectionInset: UIEdgeInsets = .zero
        var lineSpacing = defaultLineSpacing
        var itemSpacing = defaultItemSpacing
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        switch sizeClass {
        case .regular:
            let collectionViewWidth = UIScreen.main.bounds.width - 2 * padding
            let cellWidth = collectionViewWidth / (itemsCount * 2)
            let space = cellWidth / 2
            
            cellSize = CGSize(width: cellWidth, height: cellWidth)
            
            let totalCellWidth = cellWidth * itemsCount
            let totalSpacingWidth = space * (itemsCount - 1)
            let leftInset = (collectionViewWidth - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
            let rightInset = leftInset

            sectionInset = UIEdgeInsets(top: 0, left: leftInset,
                                        bottom: 0, right: rightInset)
            lineSpacing = space
            itemSpacing = space
            
        default: break
        }
        
        layout.itemSize = cellSize
        layout.sectionInset = sectionInset
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = itemSpacing
        return layout
    }
}

//
//  CellInfo.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 6/6/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

struct CellInfo {
    static var cellSnapshot : UIView? = nil
    static var cellIsAnimating : Bool = false
    static var cellNeedToShow : Bool = false
    
    static func snapshotOfCell(_ inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
}

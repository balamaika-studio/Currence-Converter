//
//  AdBannerInsetService.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 6/6/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol TableInset {
    var bannerHeight: CGFloat { get }
    var tableInset: UIEdgeInsets { get }
}

struct AdBannerInsetService: TableInset {
    static let shared = AdBannerInsetService()
    
    var bannerHeight: CGFloat {
        let height = UserDefaults.standard.float(forKey: "bannerInset")
        print(height)
        return CGFloat(height)
    }
    
    var tableInset: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0,
                            bottom: bannerHeight * 2,
                            right: 0)
    }
    
    var tableSettingsInset: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16,
                            bottom: bannerHeight * 2,
                            right: 16)
    }
    
    var graphScrollInset: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0,
                            bottom: bannerHeight,
                            right: 0)
    }
    
    private init() {}
}

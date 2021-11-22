//
//  NavBarThemeManager.swift
//  Currency Converter
//
//  Created by Александр Томашевский on 10.11.2021.
//  Copyright © 2021 Kiryl Klimiankou. All rights reserved.
//

import Foundation
import UIKit

final class NavBarThemeManager {
    
    init(appThemeManager manager: AppThemeManager) {
        apply(theme: manager.currentTheme)
        manager.subscribeToChanges(self) { [weak self] in
            self?.apply(theme: $0)
        }
    }
    
    private func apply(theme: AppTheme) {
        let titleTextAttrs: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor.white, .font: R.font.latoRegular(size: 17)!]
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = titleTextAttrs
            appearance.backgroundColor = theme.barTintColor
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            //let image = UIImage.from(color: theme.barTintColor)
            let appearance = UINavigationBar.appearance()
            appearance.barTintColor = theme.barTintColor//setBackgroundImage(image, for: .default)
            appearance.titleTextAttributes = titleTextAttrs
        }
    }
}

extension UIImage {
    
    static func from(color: UIColor, size: CGSize = .init(width: 1, height: 1)) -> UIImage {
        UIGraphicsImageRenderer(size: .init(width: 1, height: 1)).image {
            color.set()
            $0.fill(.init(origin: .zero, size: size))
        }
    }
}

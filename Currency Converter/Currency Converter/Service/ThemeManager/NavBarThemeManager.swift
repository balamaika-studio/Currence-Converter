//
//  NavBarThemeManager.swift
//  Currency Converter
//
//  Created by Vlad Sys on 16.06.22.
//  Copyright © 2022 Kiryl Klimiankou. All rights reserved.
//

import UIKit

final class NavBarThemeManager {

    init(appThemeManager manager: AppThemeManager) {
        apply(theme: manager.currentTheme)
        manager.subscribeToChanges(self) { [weak self] in
            self?.apply(theme: $0)
        }
    }

    private func apply(theme: AppTheme) {
        let titleTextAttrs: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.white,
            .font: R.font.latoRegular(size: 17)!
        ]
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.titleTextAttributes = titleTextAttrs
            appearance.backgroundColor = theme.barBackgroundColor

            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            //let image = UIImage.from(color: theme.barTintColor)
            let appearance = UINavigationBar.appearance()
            appearance.barTintColor = theme.barBackgroundColor//setBackgroundImage(image, for: .default)
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


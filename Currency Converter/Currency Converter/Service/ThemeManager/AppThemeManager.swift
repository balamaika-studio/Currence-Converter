//
//  AppThemeManager.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/23/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

final class AppThemeManager: ThemeManager {
    static let shared: AppThemeManager = .init()

    private var theme: SubscribableValue<AppTheme>

    var currentTheme: AppTheme {
        get {
            return theme.value
        }
        set {
            setNewTheme(newValue)
        }
    }

    init() {
        theme = SubscribableValue<AppTheme>(value: .light)
    }

    private func setNewTheme(_ newTheme: AppTheme) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate,
            let window = sceneDelegate.window else { return }
        
        UIView.transition(
            with: window,
            duration: 0.3,
            options: [.transitionCrossDissolve],
            animations: {
                self.theme.value = newTheme
            },
            completion: nil
        )
    }

    func subscribeToChanges(_ object: AnyObject, handler: @escaping (AppTheme) -> Void) {
        theme.subscribe(object, using: handler)
    }
}

extension Themed where Self: AnyObject {
    var themeProvider: AppThemeManager {
        return AppThemeManager.shared
    }
}

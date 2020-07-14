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
            save(theme: newValue)
            setNewTheme(newValue)
        }
    }

    init() {
        guard let themeData = UserDefaults.standard.value(forKey: "theme") as? Data,
        let savedTheme = try? JSONDecoder().decode(AppTheme.self, from: themeData) else {
            theme = SubscribableValue<AppTheme>(value: .light)
            return
        }
        theme = SubscribableValue<AppTheme>(value: savedTheme)
    }

    private func setNewTheme(_ newTheme: AppTheme) {
        guard let appDelegateWindow = UIApplication.shared.delegate?.window,
            let window = appDelegateWindow else { return }
        
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
    
    private func save(theme: Theme) {
        let themeData = try? JSONEncoder().encode(theme)
        UserDefaults.standard.set(themeData, forKey: "theme")
    }
    
}

extension Themed where Self: AnyObject {
    var themeProvider: AppThemeManager {
        return AppThemeManager.shared
    }
}

//
//  UserDefaultsService.swift
//  Currency Converter
//
//  Created by Vlad Sys on 10.09.22.
//  Copyright © 2022 Kiryl Klimiankou. All rights reserved.
//

import Foundation

class UserDefaultsService {
    static let shared = UserDefaultsService()

    var isFirstLoad: Bool {
        get {
            if UserDefaults.standard.value(forKey: "isFirstLoad") == nil { 
                UserDefaults.standard.set(true, forKey: "isFirstLoad")
            }
            let value = UserDefaults.standard.bool(forKey: "isFirstLoad")
            return value
        }

        set {
            UserDefaults.standard.set(newValue, forKey: "isFirstLoad")
        }
    }

    private init() {}
}

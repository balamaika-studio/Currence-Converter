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
            if UserDefaults.standard.value(forKey: "isFirstLoadV2") == nil {
                UserDefaults.standard.set(true, forKey: "isFirstLoadV2")
            }
            let value = UserDefaults.standard.bool(forKey: "isFirstLoadV2")
            return value
        }

        set {
            UserDefaults.standard.set(newValue, forKey: "isFirstLoadV2")
        }
    }
    
    var lastUpdateTimeInteraval: Double {
        get {
            if UserDefaults.standard.value(forKey: "lastUpdateTimeInteraval") == nil {
                UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "lastUpdateTimeInteraval")
            }
            let value = UserDefaults.standard.double(forKey: "lastUpdateTimeInteraval")
            return value
        }

        set {
            UserDefaults.standard.set(newValue, forKey: "lastUpdateTimeInteraval")
        }
    }

    private init() {}
}

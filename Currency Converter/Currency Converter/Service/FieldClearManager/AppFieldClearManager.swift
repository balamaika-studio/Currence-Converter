//
//  AppFieldClearManager.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/23/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

class AppFieldClearManager {
    static let shared = AppFieldClearManager()
    
    private var state: Bool {
        didSet { notify() }
    }
    
    var isClear: Bool {
        get { return state }
        set { state = newValue }
    }
    
    private lazy var observers = [FieldClearable]()
    
    private init() {
        state = UserDefaults.standard.bool(forKey: "clearField")
    }

    func attach(_ observer: FieldClearable) {
        observers.append(observer)
    }

    func detach(_ observer: FieldClearable) {
        if let idx = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: idx)
        }
    }

    private func notify() {
        observers.forEach({ $0.update(with: self)})
    }
}

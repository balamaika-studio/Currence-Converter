//
//  FieldClearable.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/23/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

protocol FieldClearable: class {
    func update(with manager: AppFieldClearManager)
}

extension FieldClearable where Self: AnyObject {
    func setUpClearSetting() {
        let manager = AppFieldClearManager.shared
        manager.attach(self)
        update(with: manager)
    }
}

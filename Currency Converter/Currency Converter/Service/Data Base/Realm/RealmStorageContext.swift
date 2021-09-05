//
//  RealmStorageContext.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/2/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

//import Foundation
//import RealmSwift
//
///* Storage config options */
//public enum ConfigurationType {
//    case basic
//    case named(name: String)
//}
//
//class RealmStorageContext: StorageContext {
//    private(set) var realm: Realm
//
//    required init(configuration: ConfigurationType = .basic) throws {
//        var rmConfig: Realm.Configuration
//        switch configuration {
//        case .basic:
//            rmConfig = Realm.Configuration.defaultConfiguration
//
//        case .named(let name):
//            rmConfig = Realm.Configuration()
//            rmConfig.fileURL = rmConfig.fileURL!
//                .deletingLastPathComponent()
//                .appendingPathComponent("\(name).realm")
//        }
//        try self.realm = Realm(configuration: rmConfig)
//    }
//    
//    public func safeWrite(_ block: (() throws -> Void)) throws {
//        if realm.isInWriteTransaction {
//            try block()
//        } else {
//            try realm.write(block)
//        }
//    }
//}

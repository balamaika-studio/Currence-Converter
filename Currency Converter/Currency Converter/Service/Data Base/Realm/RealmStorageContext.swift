//
//  RealmStorageContext.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/2/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation
import RealmSwift

/* Storage config options */
public enum ConfigurationType {
    case basic(url: String?)
    case named(name: String)
    case inMemory(identifier: String?)
    
    var associated: String? {
        get {
            switch self {
            case .basic(let url): return url
            case .named(let name): return name
            case .inMemory(let identifier): return identifier
            }
        }
    }
}

class RealmStorageContext: StorageContext {
    var realm: Realm?
    
    required init(configuration: ConfigurationType = .basic(url: nil)) throws {
        var rmConfig = Realm.Configuration()
        rmConfig.readOnly = true
        switch configuration {
        case .basic:
            rmConfig = Realm.Configuration.defaultConfiguration
            if let url = configuration.associated {
                rmConfig.fileURL = NSURL(string: url) as URL?
            }
            
        case .named:
            if let name = configuration.associated {
                rmConfig = Realm.Configuration()
                rmConfig.fileURL = rmConfig.fileURL!
                    .deletingLastPathComponent()
                    .appendingPathComponent("\(name).realm")
            }
            
        case .inMemory:
            rmConfig = Realm.Configuration()
            if let identifier = configuration.associated {
                rmConfig.inMemoryIdentifier = identifier
            } else {
                throw NSError()
            }
        }
        try self.realm = Realm(configuration: rmConfig)
    }
    
    public func safeWrite(_ block: (() throws -> Void)) throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        
        if realm.isInWriteTransaction {
            try block()
        } else {
            try realm.write(block)
        }
    }
}

//
//  RealmStorageContext+Operations.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/2/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation
//import RealmSwift

//typealias DataStorage = RealmSwift.Realm
//typealias DataSource<T: Storable> = RealmSwift.Results<T>

//extension RealmStorageContext {
//    func create<T: Storable>(_ model: T.Type, completion: @escaping ((T) -> Void)) throws {
//        try self.safeWrite {
//            let newObject = realm.create(model as! Object.Type, value: [], update: .modified) as! T
//            completion(newObject)
//        }
//    }
//
//    func save(object: Storable) throws {
//        try self.safeWrite {
//            realm.add(object as! Object)
//        }
//    }
//
//    func update(block: @escaping () -> Void) throws {
//        try self.safeWrite {
//            block()
//        }
//    }
//}
//
//extension RealmStorageContext {
//
//    func delete(object: Storable) throws {
//        try self.safeWrite {
//            realm.delete(object)
//        }
//    }
//
//    func deleteAll<T : Storable>(_ type: T.Type) throws {
//        try self.safeWrite {
//            realm.delete(realm.objects(type))
//        }
//    }
//}
//
//extension RealmStorageContext {
//    func fetch<T: Storable>(_ type: T.Type,
//                            predicate: NSPredicate? = nil,
//                            sorted: Sorted? = nil) -> DataSource<T> {
//        var objects = realm.objects(type)
//        if let predicate = predicate {
//            objects = objects.filter(predicate)
//        }
//        if let sorted = sorted {
//            objects = objects.sorted(byKeyPath: sorted.key, ascending: sorted.ascending)
//        }
//        return objects
//    }
//}

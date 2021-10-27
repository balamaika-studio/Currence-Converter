//
//  FileDataStore.swift
//  Currency Converter
//
//  Created by Александр Томашевский on 11.10.2021.
//  Copyright © 2021 Kiryl Klimiankou. All rights reserved.
//

import Foundation

protocol DataStoreProtocol: AnyObject {
    
    associatedtype T
    
    var name: String { get }
    var state: T? { get set }
    
    func make(mutations: (T?)->T?)
}

protocol JSONDataStoreProtocol: DataStoreProtocol where T: Codable {
    
}

final class JSONDataStoreManager {
    
    private static var stores = [String : AnyObject]()
    
    static func `default`<T: Codable>(for type: T.Type) -> AnyJSONDataStore<T> {
        let name = String(describing: T.self)
        return store(with: name, type: type)
    }
    
    static func `default`<T: Codable>() -> AnyJSONDataStore<T> {
        Self.default(for: T.self)
    }
    
    static func named<T: Codable>(_ name: String, for type: T.Type) -> AnyJSONDataStore<T> {
        let fullName = String(describing: T.self) + "_" + name
        return store(with: fullName, type: type)
    }
    
    static func named<T: Codable>(_ name: String) -> AnyJSONDataStore<T> {
        Self.named(name, for: T.self)
    }
    
    private static func store<T: Codable>(with fullName: String, type: T.Type) -> AnyJSONDataStore<T> {
        if stores[fullName] == nil {
            stores[fullName] = FileDataStore<T>(fileName: fullName)
        }
        return AnyJSONDataStore(dataStore: stores[fullName] as! FileDataStore<T>)
    }
}

final class AnyJSONDataStore<T: Codable>: JSONDataStoreProtocol {
    
    let base: Any
    let name: String
    var state: T? {
        get { _getState() }
        set { _setState(newValue) }
    }
    private let _getState: ()->T?
    private let _setState: (T?)->Void
    private let _makeMutations: ((T?)->T?)->Void
    
    init<DataStore: JSONDataStoreProtocol>(dataStore: DataStore) where DataStore.T == T {
        name = dataStore.name
        base = dataStore
        _getState = { [unowned dataStore] in dataStore.state }
        _setState = { [unowned dataStore] in dataStore.state = $0 }
        _makeMutations = { [unowned dataStore] in dataStore.make(mutations: $0) }
    }
    
    func make(mutations: (T?) -> T?) {
        _makeMutations(mutations)
    }
}

class FileDataStore<T: Codable>: JSONDataStoreProtocol {
    
    let queue = DispatchQueue(label: "\(FileDataStore<T>.self) queue", qos: .utility, attributes: .concurrent)
    private lazy var _state: T? = load()
    var state: T? {
        get { queue.sync { _state } }
        set { queue.async(flags: .barrier) { [unowned self] in
            self._state = newValue
            self.save(state: newValue)
        } }
    }
    let fileName: String
    var name: String { fileName }
    let manager = FileManager.default
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    private(set) lazy var path: URL? = {
        guard let path = manager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fullPath = path.appendingPathComponent(fileName).appendingPathExtension("json")
        return fullPath
    }()
    
    fileprivate init(fileName: String) {
        self.fileName = fileName
    }
    
    func load() -> T? {
        guard let path = path, let data = try? Data(contentsOf: path), let model = try? decoder.decode(T.self, from: data) else { return nil }
        return model
    }
    
    func make(mutations: (T?)->T?) {
        state = mutations(state)
    }
    
    //do not use out of queue
    private func save(state _state: T?) {
        guard let state = _state else { deleteStateFile(); return }
        guard let path = path, let data = try? encoder.encode(state) else { return }
        try? data.write(to: path, options: .atomic)
    }
    
    //do not use out of queue
    private func deleteStateFile() {
        guard let path = path else { return }
        try? manager.removeItem(at: path)
    }
}

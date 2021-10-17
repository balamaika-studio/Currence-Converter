//
//  CachedResult.swift
//  Currency Converter
//
//  Created by Александр Томашевский on 18.10.2021.
//  Copyright © 2021 Kiryl Klimiankou. All rights reserved.
//

import Foundation

enum CachedResult<T> {
    
    case error(String, cache: T?)
    case success(T)
    case none

    var value: T? {
        switch self {
        case let .error(error, cache): return cache
        case .success(let value): return value
        case .none: return nil
        }
    }
    
    init(value: T?) {
        if let value = value {
            self = .success(value)
        } else {
            self = .none
        }
    }
    
    func map<N>(transform: (T)->N) -> CachedResult<N> {
        switch self {
        case let .error(error, cache): return CachedResult<N>.error(error, cache: transform(cache))
        case .none: return CachedResult<N>.none
        case .success(let model): return CachedResult<N>.success(transform(model))
        }
    }
}

//
//  RxRelay+Infallible.swift
//  Coral Health
//
//  Created by Александр Томашевский on 08.10.2021.
//

import RxSwift
import RxRelay

protocol RelayType: ObservableType { }

extension RelayType {
    
    func asInfallible() -> Infallible<Element> {
        asInfallible(onErrorRecover: { _ in fatalError() })
    }
}

extension PublishRelay: RelayType { }

extension BehaviorRelay: RelayType { }

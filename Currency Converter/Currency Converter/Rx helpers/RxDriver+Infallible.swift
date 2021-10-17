//
//  RxDriver+Infallible.swift
//  Coral Health
//
//  Created by Александр Томашевский on 08.10.2021.
//

import RxCocoa
import RxSwift

extension Infallible {
    
    func asDriver() -> Driver<Element> {
        asDriver { _ in fatalError() }
    }
}

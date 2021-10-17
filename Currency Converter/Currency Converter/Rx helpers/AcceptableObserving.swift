//
//  AcceptableObserving.swift
//  Coral Health
//
//  Created by Александр Томашевский on 31.08.2021.
//

import RxRelay
import RxSwift

protocol AcceptableObserving {
    
    associatedtype T
    
    func accept(_ value: T)
}

extension PublishRelay: AcceptableObserving { }
extension BehaviorRelay: AcceptableObserving { }

struct AcceptableObserver<T>: AcceptableObserving, ObserverType {
    
    private enum Observer {
        case publishRelay(PublishRelay<T>)
        case behaviorRelay(BehaviorRelay<T>)
        case anyObserver(AnyObserver<T>)
    }
    
    private let observer: Observer
    
    init(eventHandler: @escaping (T)->Void) {
        observer = .anyObserver(.init(eventHandler: { event in
            guard case let .next(value) = event else { return }
            eventHandler(value)
        }))
    }
    
    init(relay: PublishRelay<T>) {
        observer = .publishRelay(relay)
    }
    
    init(relay: BehaviorRelay<T>) {
        observer = .behaviorRelay(relay)
    }
    
    func accept(_ value: T) {
        switch observer {
        case .anyObserver(let observer): observer.onNext(value)
        case .behaviorRelay(let relay): relay.accept(value)
        case .publishRelay(let relay): relay.accept(value)
        }
    }
    
    func on(_ event: Event<T>) {
        event.element.map({ accept($0) })
    }
}

extension ObservableType {
    
    func bind<Observer: AcceptableObserving>(to observer: Observer) -> RxSwift.Disposable where Observer.T == Self.Element {
        subscribe(onNext: { observer.accept($0) })
    }
}

extension AcceptableObserver where T == Void {
    func accept() {
        accept(())
    }
}

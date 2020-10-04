//
//  AnyStateMachine.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import Foundation

/// Type erasure implementation of `StateMachine`
struct AnyStateMachine<Item: Emptiable>: StateMachine {
    
    // MARK: - StateMachine
    
    func present(state: Loadable<Item>, provider: StateMachineViewProvider) {
        presentHandler(state, provider)
    }
    
    // MARK: - Private
    
    private let presentHandler: (Loadable<Item>, StateMachineViewProvider) -> Void
    
    // MARK: - Init
    
    init<S: StateMachine>(_ source: S) where S.Item == Item {
        self.presentHandler = source.present
    }
}

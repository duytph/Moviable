//
//  SpyStateMachine.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/5/20.
//

import Foundation
@testable import Movieable

final class SpyStateMachine<Item: Emptiable>: StateMachine {
    
    var invokedPresent = false
    var invokedPresentCount = 0
    var invokedPresentParameters: (state: Loadable<Item>, provider: StateMachineViewProvider)?
    var invokedPresentParametersList = [(state: Loadable<Item>, provider: StateMachineViewProvider)]()

    func present(
        state: Loadable<Item>,
        provider: StateMachineViewProvider) {
        invokedPresent = true
        invokedPresentCount += 1
        invokedPresentParameters = (state, provider)
        invokedPresentParametersList.append((state, provider))
    }
}

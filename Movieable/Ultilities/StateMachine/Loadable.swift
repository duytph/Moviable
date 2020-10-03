//
//  Loadable.swift
//  Movieable
//
//  Created by Duy Tran on 10/3/20.
//

import Foundation

enum Loadable<T> {

    case idle
    case isLoading(last: T?)
    case loaded(T)
    case failed(Error)

    var value: T? {
        switch self {
        case let .loaded(value): return value
        case let .isLoading(last): return last
        case .idle, .failed: return nil
        }
    }
    
    var error: Error? {
        switch self {
        case let .failed(error): return error
        case .idle, .isLoading, .loaded: return nil
        }
    }
}

extension Loadable: Equatable where T: Equatable {
    
    static func == (lhs: Loadable<T>, rhs: Loadable<T>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case let (.isLoading(lhsItem), .isLoading(rhsItem)):
            return lhsItem == rhsItem
        case let (.loaded(lhsItem), .loaded(rhsItem)):
            return lhsItem == rhsItem
        case let (.failed(lhsError), .failed(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default: return false
        }
    }
}

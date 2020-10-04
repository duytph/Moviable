//
//  StateMachine.swift
//  Movieable
//
//  Created by Duy Tran on 10/3/20.
//

import UIKit

/// Manage stateful views covering up underlying content
protocol StateMachine {
    
    associatedtype Item: Emptiable
    
    /// Cover underlying content view up with stateful view associated with input state
    func present(
        state: Loadable<Item>,
        provider: StateMachineViewProvider)
}

extension StateMachine {
    
    func eraseToAnyStateMachine() -> AnyStateMachine<Item> {
        AnyStateMachine(self)
    }
}

struct DefaultStateMachine<Item: Emptiable>: StateMachine {
    
    init() {}
    
    func present(
        state: Loadable<Item>,
        provider: StateMachineViewProvider) {
        let parentView = provider.parentView
        let constrainedTargetView = provider.constrainedTargetView
        let view: UIView
        switch state {
        case .idle, .isLoading(.some):
            view = provider.contentView
        case .isLoading(.none):
            view = provider.loadingView()
        case let .loaded(item):
            view = item.isEmpty ? provider.emptyView() : provider.contentView
        case let .failed(error):
            view = provider.errorView(error: error)
        }
        
        present(
            view: view,
            parentView: parentView,
            constrainedTargetView: constrainedTargetView)
    }
    
    func present(
        view: UIView,
        parentView: UIView,
        constrainedTargetView: UIView) {
        if view.isDescendant(of: parentView) {
            parentView.bringSubviewToFront(view)
        } else {
            parentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: constrainedTargetView.topAnchor),
                view.leadingAnchor.constraint(equalTo: constrainedTargetView.leadingAnchor),
                view.bottomAnchor.constraint(equalTo: constrainedTargetView.bottomAnchor),
                view.trailingAnchor.constraint(equalTo: constrainedTargetView.trailingAnchor),
            ])
        }
    }
}

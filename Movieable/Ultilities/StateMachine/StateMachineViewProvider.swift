//
//  StateMachineViewProvider.swift
//  Movieable
//
//  Created by Duy Tran on 10/3/20.
//

import UIKit

/// Auxiliary part of `StateMachine`, providing material views for its state presentation
protocol StateMachineViewProvider: AnyObject {
    
    /// View that stateful views should be added as subview
    var parentView: UIView { get }
    
    /// View that stateful views should be constrained by
    var constrainedTargetView: UIView { get }
    
    /// Actual underlying content view, that should be covered up by stateful views
    var contentView: UIView { get }
    
    /// Stateful view that will cover underlying content view up when having no data
    func emptyView() -> UIView
    
    /// Stateful view that will cover underlying content view up when loading
    func loadingView() -> UIView
    
    /// Stateful view that will cover underlying content view up when encountering error
    func errorView(error: Error) -> UIView
}

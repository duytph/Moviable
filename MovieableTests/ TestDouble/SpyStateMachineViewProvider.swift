//
//  SpyStateMachineViewProvider.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/3/20.
//

import UIKit
@testable import Movieable

final class SpyStateMachineViewProvider: StateMachineViewProvider {

    var invokedParentViewGetter = false
    var invokedParentViewGetterCount = 0
    var stubbedParentView: UIView!

    var parentView: UIView {
        invokedParentViewGetter = true
        invokedParentViewGetterCount += 1
        return stubbedParentView
    }

    var invokedConstrainedTargetViewGetter = false
    var invokedConstrainedTargetViewGetterCount = 0
    var stubbedConstrainedTargetView: UIView!

    var constrainedTargetView: UIView {
        invokedConstrainedTargetViewGetter = true
        invokedConstrainedTargetViewGetterCount += 1
        return stubbedConstrainedTargetView
    }

    var invokedContentViewGetter = false
    var invokedContentViewGetterCount = 0
    var stubbedContentView: UIView!

    var contentView: UIView {
        invokedContentViewGetter = true
        invokedContentViewGetterCount += 1
        return stubbedContentView
    }

    var invokedEmtyView = false
    var invokedEmtyViewCount = 0
    var stubbedEmtyViewResult: UIView!

    func emptyView() -> UIView {
        invokedEmtyView = true
        invokedEmtyViewCount += 1
        return stubbedEmtyViewResult
    }

    var invokedLoadingView = false
    var invokedLoadingViewCount = 0
    var stubbedLoadingViewResult: UIView!

    func loadingView() -> UIView {
        invokedLoadingView = true
        invokedLoadingViewCount += 1
        return stubbedLoadingViewResult
    }

    var invokedErrorView = false
    var invokedErrorViewCount = 0
    var invokedErrorViewParameters: (error: Error, Void)?
    var invokedErrorViewParametersList = [(error: Error, Void)]()
    var stubbedErrorViewResult: UIView!

    func errorView(error: Error) -> UIView {
        invokedErrorView = true
        invokedErrorViewCount += 1
        invokedErrorViewParameters = (error, ())
        invokedErrorViewParametersList.append((error, ()))
        return stubbedErrorViewResult
    }
}

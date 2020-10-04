//
//  SpyMoviesListPresentable.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/5/20.
//

import Foundation
@testable import Movieable

final class SpyMoviesListPresentable: MoviesListPresentable {

    var invokedTitleSetter = false
    var invokedTitleSetterCount = 0
    var invokedTitle: String?
    var invokedTitleList = [String?]()
    var invokedTitleGetter = false
    var invokedTitleGetterCount = 0
    var stubbedTitle: String!

    var title: String? {
        set {
            invokedTitleSetter = true
            invokedTitleSetterCount += 1
            invokedTitle = newValue
            invokedTitleList.append(newValue)
        }
        get {
            invokedTitleGetter = true
            invokedTitleGetterCount += 1
            return stubbedTitle
        }
    }

    var invokedPresent = false
    var invokedPresentCount = 0
    var invokedPresentParameters: (state: Loadable<[Movie]>, Void)?
    var invokedPresentParametersList = [(state: Loadable<[Movie]>, Void)]()

    func present(state: Loadable<[Movie]>) {
        invokedPresent = true
        invokedPresentCount += 1
        invokedPresentParameters = (state, ())
        invokedPresentParametersList.append((state, ()))
    }

    var invokedEndRefreshing = false
    var invokedEndRefreshingCount = 0

    func endRefreshing() {
        invokedEndRefreshing = true
        invokedEndRefreshingCount += 1
    }
}

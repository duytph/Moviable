//
//  SpyMoviesListViewModel.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/5/20.
//

import Foundation
@testable import Movieable

final class SpyMoviesListViewModel: MoviesListViewModel {

    var invokedPresenterSetter = false
    var invokedPresenterSetterCount = 0
    var invokedPresenter: MoviesListPresentable?
    var invokedPresenterList = [MoviesListPresentable?]()
    var invokedPresenterGetter = false
    var invokedPresenterGetterCount = 0
    var stubbedPresenter: MoviesListPresentable!

    var presenter: MoviesListPresentable? {
        set {
            invokedPresenterSetter = true
            invokedPresenterSetterCount += 1
            invokedPresenter = newValue
            invokedPresenterList.append(newValue)
        }
        get {
            invokedPresenterGetter = true
            invokedPresenterGetterCount += 1
            return stubbedPresenter
        }
    }

    var invokedViewDidLoad = false
    var invokedViewDidLoadCount = 0

    func viewDidLoad() {
        invokedViewDidLoad = true
        invokedViewDidLoadCount += 1
    }

    var invokedRefresh = false
    var invokedRefreshCount = 0

    func refresh() {
        invokedRefresh = true
        invokedRefreshCount += 1
    }

    var invokedLoadMore = false
    var invokedLoadMoreCount = 0

    func loadMore() {
        invokedLoadMore = true
        invokedLoadMoreCount += 1
    }

    var invokedDidSelect = false
    var invokedDidSelectCount = 0
    var invokedDidSelectParameters: (movie: Movie, Void)?
    var invokedDidSelectParametersList = [(movie: Movie, Void)]()

    func didSelect(movie: Movie) {
        invokedDidSelect = true
        invokedDidSelectCount += 1
        invokedDidSelectParameters = (movie, ())
        invokedDidSelectParametersList.append((movie, ()))
    }
}

//
//  SpyMovieDetailViewModel.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/5/20.
//

import Foundation
@testable import Movieable

final class SpyMovieDetailViewModel: MovieDetailViewModel {

    var invokedPresenterSetter = false
    var invokedPresenterSetterCount = 0
    var invokedPresenter: MovieDetailPresentable?
    var invokedPresenterList = [MovieDetailPresentable?]()
    var invokedPresenterGetter = false
    var invokedPresenterGetterCount = 0
    var stubbedPresenter: MovieDetailPresentable!

    var presenter: MovieDetailPresentable? {
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

    var invokedBookButtonDidTap = false
    var invokedBookButtonDidTapCount = 0

    func bookButtonDidTap() {
        invokedBookButtonDidTap = true
        invokedBookButtonDidTapCount += 1
    }
}

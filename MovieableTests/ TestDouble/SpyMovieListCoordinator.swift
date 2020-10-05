//
//  SpyMovieListCoordinator.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/5/20.
//

import UIKit
@testable import Movieable

final class SpyMovieListCoordinator: MovieListCoordinator {

    var invokedChildrenSetter = false
    var invokedChildrenSetterCount = 0
    var invokedChildren: [Coordinator]?
    var invokedChildrenList = [[Coordinator]]()
    var invokedChildrenGetter = false
    var invokedChildrenGetterCount = 0
    var stubbedChildren: [Coordinator]! = []

    var children: [Coordinator] {
        set {
            invokedChildrenSetter = true
            invokedChildrenSetterCount += 1
            invokedChildren = newValue
            invokedChildrenList.append(newValue)
        }
        get {
            invokedChildrenGetter = true
            invokedChildrenGetterCount += 1
            return stubbedChildren
        }
    }

    var invokedNavigationControllerGetter = false
    var invokedNavigationControllerGetterCount = 0
    var stubbedNavigationController: UINavigationController!

    var navigationController: UINavigationController {
        invokedNavigationControllerGetter = true
        invokedNavigationControllerGetterCount += 1
        return stubbedNavigationController
    }

    var invokedRouteToMovieDetail = false
    var invokedRouteToMovieDetailCount = 0
    var invokedRouteToMovieDetailParameters: (movie: Movie, Void)?
    var invokedRouteToMovieDetailParametersList = [(movie: Movie, Void)]()

    func routeToMovieDetail(movie: Movie) {
        invokedRouteToMovieDetail = true
        invokedRouteToMovieDetailCount += 1
        invokedRouteToMovieDetailParameters = (movie, ())
        invokedRouteToMovieDetailParametersList.append((movie, ()))
    }

    var invokedOpen = false
    var invokedOpenCount = 0
    var invokedOpenParameters: (url: URL, animated: Bool)?
    var invokedOpenParametersList = [(url: URL, animated: Bool)]()
    var shouldInvokeOpenCompletion = false

    func open(
        url: URL,
        animated: Bool,
        completion: (() -> Void)?) {
        invokedOpen = true
        invokedOpenCount += 1
        invokedOpenParameters = (url, animated)
        invokedOpenParametersList.append((url, animated))
        if shouldInvokeOpenCompletion {
            completion?()
        }
    }

    var invokedStart = false
    var invokedStartCount = 0

    func start() {
        invokedStart = true
        invokedStartCount += 1
    }

    var invokedAdd = false
    var invokedAddCount = 0
    var invokedAddParameters: (child: Coordinator, Void)?
    var invokedAddParametersList = [(child: Coordinator, Void)]()

    func add(child: Coordinator) {
        invokedAdd = true
        invokedAddCount += 1
        invokedAddParameters = (child, ())
        invokedAddParametersList.append((child, ()))
    }
}

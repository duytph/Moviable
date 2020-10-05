//
//  MockMovieDetailCoordinator.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/5/20.
//

import UIKit
@testable import Movieable

final class MockMovieDetailCoordinator: MovieDetailCoordinator {
    
    var children: [Coordinator]
    
    var navigationController: UINavigationController
    
    init(
        children: [Coordinator],
        navigationController: UINavigationController) {
        self.children = children
        self.navigationController = navigationController
    }
    
    func start() {}
}

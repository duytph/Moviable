//
//  AppCoordinator.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import UIKit

protocol AppCoordinator: Coordinator {}

final class DefaultAppCoordinator: AppCoordinator {
    
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        let viewModel = PopularMoviesViewModel()
        viewModel.coordinator = self
        let viewController = MoviesListViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

extension DefaultAppCoordinator: MovieListCoordinator {}

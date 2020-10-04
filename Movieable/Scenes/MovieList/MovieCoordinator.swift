//
//  MovieCoordinator.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import Foundation

protocol MovieListCoordinator: Coordinator {
    
    func routeToMovieDetail(movie: Movie)
}

extension MovieListCoordinator {
    
    func routeToMovieDetail(movie: Movie) {
        let viewModel = DefaultMovieDetailViewModel(movie: movie)
        let viewController = MovieDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

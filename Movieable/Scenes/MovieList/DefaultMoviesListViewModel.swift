//
//  DefaultMoviesListViewModel.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import Combine
import Foundation

protocol MoviesListPresentable: AnyObject {
    
    var title: String? { get set }
    
    func present(state: Loadable<[Movie]>)
    func endRefreshing()
}

class DefaultMoviesListViewModel: MoviesListViewModel {
    
    // MARK: - Dependencies

    weak var presenter: MoviesListPresentable?
    weak var coordinator: MovieListCoordinator?
    
    let title: String
    
    @Published var state: Loadable<[Movie]>
    
    var cancelBag = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(
        title: String = NSLocalizedString("Movies", comment: ""),
        movies: [Movie] = []) {
        self.title = title
        self.state = .loaded(movies)
    }
    
    // MARK: - MoviesListViewModel
    
    func viewDidLoad() {
        presenter?.title = title
        $state.sink { [weak presenter] (state: Loadable<[Movie]>) in
            presenter?.present(state: state)
        }
        .store(in: &cancelBag)
    }
    
    func refresh() {
        presenter?.endRefreshing()
    }
    
    func loadMore() {}

    func didSelect(movie: Movie) {
        coordinator?.routeToMovieDetail(movie: movie)
    }
}

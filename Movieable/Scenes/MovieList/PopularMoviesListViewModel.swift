//
//  PopularMoviesListViewModel.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import Combine
import Foundation

final class PopularMoviesListViewModel: MoviesListViewModel {
    
    // MARK: - Dependencies

    weak var presenter: MoviesListPresentable?
    weak var coordinator: MovieListCoordinator?
    
    let movieRepository: MovieRepository
    let title: String
    @Published var state: Loadable<[Movie]>
    var cancelBag = Set<AnyCancellable>()
    
    private var nextPage: Int = 1
    private var totalPages: Int = 1
    
    init(
        movieRepository: MovieRepository = DefaultMovieRepository.shared,
        title: String = NSLocalizedString("Popular", comment: ""),
        movies: [Movie] = []) {
        self.movieRepository = movieRepository
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
        
        refresh()
    }
    
    func refresh() {
        nextPage = 1
        totalPages = 1
        fetch(isRefresh: true)
    }
    
    func loadMore() {
        fetch(isRefresh: false)
    }
    
    func didSelect(movie: Movie) {
        coordinator?.routeToMovieDetail(movie: movie)
    }
    
    // MARK: - Public
    
    func fetch(isRefresh: Bool) {
        guard nextPage <= totalPages else { return }
        
        let last = state.value
        self.state = .isLoading(last: last)
        
        movieRepository
            .popular(page: nextPage)
            .sink(
                receiveCompletion: { [weak self] (completion: Subscribers.Completion<Error>) in
                    guard
                        let self = self,
                        case let .failure(error) = completion
                    else { return }
                    self.state = .failed(error)
                    if isRefresh {
                        self.presenter?.endRefreshing()
                    }
                },
                receiveValue: { (response: PaginationResponse<Movie>) in
                    self.nextPage = response.page + 1
                    self.totalPages = response.totalPages
                    let movies = isRefresh
                        ? response.results
                        : (self.state.value ?? []) + response.results
                    self.state = .loaded(movies)
                    if isRefresh {
                        self.presenter?.endRefreshing()
                    }
                })
            .store(in: &cancelBag)
    }
}

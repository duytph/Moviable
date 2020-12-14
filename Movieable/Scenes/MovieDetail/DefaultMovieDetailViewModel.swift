//
//  DefaultMovieDetailViewModel.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import Combine
import Foundation

protocol MovieDetailPresentable: AnyObject {
    
    var title: String? { get set }
    
    func present(state: Loadable<Movie>)
}

final class DefaultMovieDetailViewModel: MovieDetailViewModel {
    
    // MARK: - Dependencies
    
    weak var presenter: MovieDetailPresentable?
    weak var coordinator: MovieDetailCoordinator?
    
    let movieRepository: MovieRepository
    let bookingURL: URL?
    @Published var state: Loadable<Movie> = .idle
    var cancelBag = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(
        movieRepository: MovieRepository = DefaultMovieWebRepository.shared,
        bookingURL: URL? = URL(string: "https://www.cathaycineplexes.com.sg/"),
        movie: Movie) {
        self.movieRepository = movieRepository
        self.bookingURL = bookingURL
        self.state = .loaded(movie)
    }
    
    // MARK: - MovieDetailViewModel
    
    func viewDidLoad() {
        $state.sink { [weak presenter] (state: Loadable<Movie>) in
            presenter?.present(state: state)
        }
        .store(in: &cancelBag)
        
        guard let movie = state.value else { return }
        presenter?.title = movie.title
        fetchMovie(id: movie.id)
    }
    
    func refresh() {
        guard let movie = state.value else { return }
        fetchMovie(id: movie.id)
    }
    
    func bookButtonDidTap() {
        guard let bookingURL = self.bookingURL else { return }
        coordinator?.open(
            url: bookingURL,
            animated: true,
            completion: nil)
    }
    
    // MARK: - Public
    
    func fetchMovie(id: Int) {
        state = .isLoading(last: state.value)
        
        movieRepository
            .movie(id: id)
            .sink(
                receiveCompletion: { [weak self] (completion: Subscribers.Completion<Error>) in
                    switch completion {
                    case let .failure(error):
                        self?.state = .failed(error)
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] (movie: Movie) in
                    self?.state = .loaded(movie)
                })
            .store(in: &cancelBag)
    }
}

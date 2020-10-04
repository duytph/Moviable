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
}

final class DefaultMovieDetailViewModel: MovieDetailViewModel {
    
    // MARK: - Dependencies
    
    weak var presenter: MovieDetailPresentable?
    
    let movieRepository: MovieRepository
    @Published var state: Loadable<Movie> = .idle
    var cancelBag = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(
        movieRepository: MovieRepository = DefaultMovieRepository.shared,
        movie: Movie) {
        self.movieRepository = movieRepository
        self.state = .loaded(movie)
    }
    
    // MARK: - MovieDetailViewModel
    
    func viewDidLoad() {
        guard let movie = state.value else { return }
        presenter?.title = movie.title
        fetchMovie(id: movie.id)
    }
    
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

//
//  DefaultMovieDetailViewModel.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import Foundation

protocol MovieDetailPresentable: AnyObject {
    
    var title: String? { get set }
}

final class DefaultMovieDetailViewModel: MovieDetailViewModel {
    
    // MARK: - Dependencies
    
    weak var presenter: MovieDetailPresentable?
    
    let movie: Movie
    
    // MARK: - Init
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    // MARK: - MovieDetailViewModel
    
    func viewDidLoad() {
        presenter?.title = movie.title
    }
}

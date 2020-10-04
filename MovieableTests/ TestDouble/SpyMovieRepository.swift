//
//  SpyMovieRepository.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/5/20.
//

import Combine
import Foundation
@testable import Movieable

final class SpyMovieRepository: MovieRepository {

    var invokedPopular = false
    var invokedPopularCount = 0
    var invokedPopularParameters: (page: Int, Void)?
    var invokedPopularParametersList = [(page: Int, Void)]()
    var stubbedPopularResult: AnyPublisher<PaginationResponse<Movie>, Error>!

    func popular(page: Int) -> AnyPublisher<PaginationResponse<Movie>, Error> {
        invokedPopular = true
        invokedPopularCount += 1
        invokedPopularParameters = (page, ())
        invokedPopularParametersList.append((page, ()))
        return stubbedPopularResult
    }

    var invokedMovie = false
    var invokedMovieCount = 0
    var invokedMovieParameters: (id: Int, Void)?
    var invokedMovieParametersList = [(id: Int, Void)]()
    var stubbedMovieResult: AnyPublisher<Movie, Error>!

    func movie(id: Int) -> AnyPublisher<Movie, Error> {
        invokedMovie = true
        invokedMovieCount += 1
        invokedMovieParameters = (id, ())
        invokedMovieParametersList.append((id, ()))
        return stubbedMovieResult
    }
}

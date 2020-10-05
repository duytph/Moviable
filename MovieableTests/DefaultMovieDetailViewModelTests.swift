//
//  DefaultMovieDetailViewModelTests.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/5/20.
//

import Combine
import XCTest
@testable import Movieable

final class DefaultMovieDetailViewModelTests: XCTestCase {

    var presenter: SpyMovieDetailPresentable!
    var coordinator:  SpyMovieDetailCoordinator!
    var movieRepository: SpyMovieRepository!
    var bookingURL: URL!
    var movie: Movie!
    var sut: DefaultMovieDetailViewModel!
    
    override func setUpWithError() throws {
        presenter = SpyMovieDetailPresentable()
        coordinator = SpyMovieDetailCoordinator()
        movieRepository = SpyMovieRepository()
        movieRepository.stubbedMovieResult = Empty().eraseToAnyPublisher()
        bookingURL = URL(string: "https://9gag.com")!
        movie = .mock
        sut = DefaultMovieDetailViewModel(
            movieRepository: movieRepository,
            bookingURL: bookingURL,
            movie: movie)
        sut.presenter = presenter
        sut.coordinator = coordinator
    }

    override func tearDownWithError() throws {
        presenter = nil
        coordinator = nil
        movieRepository = nil
        bookingURL = nil
        movie = nil
        sut = nil
    }
    
    func testInit() throws {
        XCTAssertTrue(sut.presenter  === presenter)
        XCTAssertTrue(sut.coordinator === coordinator)
        XCTAssertTrue(sut.movieRepository as! SpyMovieRepository === movieRepository)
        XCTAssertEqual(sut.bookingURL, bookingURL)
        XCTAssertEqual(sut.state, .loaded(movie))
    }
    
    func testViewDidLoad() {
        sut.viewDidLoad()
        
        XCTAssertTrue(presenter.invokedTitleSetter)
        XCTAssertTrue(movieRepository.invokedMovie)
        XCTAssertEqual(movieRepository.invokedMovieParameters?.id, movie.id)
    }
    
    func testBookButtonDidTap() {
        sut.bookButtonDidTap()
        XCTAssertTrue(coordinator.invokedOpen)
        XCTAssertEqual(coordinator.invokedOpenParameters?.url, bookingURL)
    }
    
    func testFetchMovieFailed() {
        let id = 0
        let error = StubError()
        movieRepository.stubbedMovieResult = Fail(error: error).eraseToAnyPublisher()
        
        sut.fetchMovie(id: id)
        
        XCTAssertTrue(movieRepository.invokedMovie)
        XCTAssertEqual(movieRepository.invokedMovieParameters?.id, id)
        XCTAssertEqual(sut.state, .failed(error))
    }
    
    func testFetchMovie() {
        let id = 0
        movieRepository.stubbedMovieResult = Future<Movie, Error> { $0(.success(self.movie)) }.eraseToAnyPublisher()
        
        sut.fetchMovie(id: id)
        
        XCTAssertTrue(movieRepository.invokedMovie)
        XCTAssertEqual(movieRepository.invokedMovieParameters?.id, id)
        XCTAssertEqual(sut.state, .loaded(movie))
    }
}

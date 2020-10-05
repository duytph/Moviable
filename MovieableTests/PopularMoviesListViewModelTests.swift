//
//  PopularMoviesListViewModelTests.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/5/20.
//

import Combine
import XCTest
@testable import Movieable

final class PopularMoviesListViewModelTests: XCTestCase {
    
    var presenter: SpyMoviesListPresentable!
    var coordinator: SpyMovieListCoordinator!
    var movieRepository: SpyMovieRepository!
    var title: String!
    var movie: Movie!
    var movies: [Movie]!
    var sut: PopularMoviesListViewModel!

    override func setUpWithError() throws {
        presenter = SpyMoviesListPresentable()
        coordinator = SpyMovieListCoordinator()
        movieRepository = SpyMovieRepository()
        movieRepository.stubbedPopularResult = Empty().eraseToAnyPublisher()
        title = "Foo"
        movie = try! JSONDecoder().decode(
            Movie.self,
            from: #"{ "id": 1 }"#.data(using: .utf8)!)
        movies = []
        sut = PopularMoviesListViewModel(
            movieRepository: movieRepository,
            title: title,
            movies: movies)
        sut.presenter = presenter
        sut.coordinator = coordinator
    }
    
    override func tearDownWithError() throws {
        presenter = nil
        coordinator = nil
        movieRepository = nil
        title = nil
        movie = nil
        movies = nil
        sut = nil
    }
    
    func testInit() throws {
        XCTAssertTrue(sut.presenter === presenter)
        XCTAssertTrue(sut.coordinator === coordinator)
        XCTAssertTrue(sut.movieRepository as! SpyMovieRepository === movieRepository)
        XCTAssertEqual(sut.title, title)
        XCTAssertEqual(sut.state, .loaded(movies))
    }
    
    func testViewDidLoad() throws {
        sut.viewDidLoad()
        XCTAssertEqual(sut.title, presenter.invokedTitle)
        XCTAssertFalse(sut.cancelBag.isEmpty)
    }
    
    func testRefresh() throws {
        sut.refresh()
        XCTAssertTrue(movieRepository.invokedPopular)
        XCTAssertEqual(movieRepository.invokedPopularParameters?.page, 1)
    }
    
    func testLoadMore() throws {
        sut.loadMore()
        XCTAssertTrue(movieRepository.invokedPopular)
        XCTAssertEqual(movieRepository.invokedPopularParameters?.page, 1)
    }
    
    func testDidSelectMovie() throws {
        sut.didSelect(movie: movie)
        XCTAssertTrue(coordinator.invokedRouteToMovieDetail)
        XCTAssertEqual(coordinator.invokedRouteToMovieDetailParameters?.movie, movie)
    }
    
    func testFetch() throws {
        let response = PaginationResponse(
            page: 1,
            totalResults: 1,
            totalPages: 1,
            results: movies)
        movieRepository.stubbedPopularResult = Future<PaginationResponse<Movie>, Error> { (promise: @escaping Future<PaginationResponse<Movie>, Error>.Promise) in
            promise(.success(response))
        }
        .eraseToAnyPublisher()
        
        sut.fetch(isRefresh: true)
        
        XCTAssertEqual(sut.state, .loaded(movies))
    }
    
    func testFetchFailed() throws {
        let error = StubError()
        movieRepository.stubbedPopularResult = Future<PaginationResponse<Movie>, Error> { (promise: @escaping Future<PaginationResponse<Movie>, Error>.Promise) in
            promise(.failure(error))
        }
        .eraseToAnyPublisher()
        
        sut.fetch(isRefresh: false)
        
        XCTAssertEqual(sut.state, .failed(error))
    }
}

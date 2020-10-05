//
//  MovieDetailViewControllerTests.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/5/20.
//

import XCTest
@testable import Movieable

final class MovieDetailViewControllerTests: XCTestCase {
    
    var movie: Movie!
    var error: StubError!
    var viewModel: SpyMovieDetailViewModel!
    var stateMachine: SpyStateMachine<Movie>!
    var imageURLFactory: SpyImageURLFactory!
    var sut: MovieDetailViewController!

    override func setUpWithError() throws {
        movie = .mock
        error = StubError()
        viewModel = SpyMovieDetailViewModel()
        stateMachine = SpyStateMachine<Movie>()
        imageURLFactory = SpyImageURLFactory()
        imageURLFactory.images = .defaultValue
        sut = MovieDetailViewController(
            viewModel: viewModel,
            stateMachine: stateMachine.eraseToAnyStateMachine(),
            imageURLFactory: imageURLFactory)
    }

    override func tearDownWithError() throws {
        movie = nil
        error = nil
        viewModel = nil
        stateMachine = nil
        imageURLFactory = nil
        sut = nil
    }

    func testViewDidLoad() throws {
        sut.loadViewIfNeeded()
        XCTAssertTrue(viewModel.invokedViewDidLoad)
    }
    
    func testPresentState() throws {
        sut.loadViewIfNeeded()
        
        let states: [Loadable<Movie>] = [
            .idle,
            .isLoading(last: nil),
            .isLoading(last: movie),
            .loaded(movie),
            .failed(error)
        ]
        
        states.forEach {
            sut.present(state: $0)
            XCTAssertTrue(stateMachine.invokedPresent)
            XCTAssertEqual(stateMachine.invokedPresentParameters?.state, $0)
        }
    }
    
    func testConfigureWithMovie() throws {
        sut.loadViewIfNeeded()
        sut.configure(withMovie: movie)
        
        XCTAssertTrue(imageURLFactory.invokedMakeIsSecure)
        XCTAssertNotNil(sut.imageView.kf.placeholder)
        XCTAssertTrue(sut.titleLabel.text!.contains(movie.title!))
        XCTAssertTrue(
            movie
                .genres!
                .compactMap { sut.genresLabel.text!.contains($0.name!) }
                .reduce(true, { $0 && $1 }))
        XCTAssertTrue(
            movie
                .spokenLanguages!
                .compactMap { sut.spokenLanguagesLabel.text!.contains($0.name!) }
                .reduce(true, { $0 && $1 }))
        XCTAssertTrue(sut.overviewLabel.text!.contains(movie.overview!))
    }
    
    func testBookButtonDidTap() throws {
        sut.bookButtonDidTap(sut.bookButton as Any)
        XCTAssertTrue(viewModel.invokedBookButtonDidTap)
    }
}

//
//  DefaultMovieRepositoryEndpointTests.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/5/20.
//

import XCTest
@testable import Movieable

final class DefaultMovieRepositoryEndpointTests: XCTestCase {
    
    func testPopular() {
        let page = 0
        let sut = DefaultMovieRepository.APIEndpoint.popular(page: 0)
        XCTAssertEqual(sut.path, "/movie/popular?page=\(page)")
        XCTAssertEqual(sut.method, .get)
        XCTAssertNoThrow(try sut.body())
        XCTAssertNil(try sut.body())
    }
    
    func testMovie() {
        let id = 0
        let sut = DefaultMovieRepository.APIEndpoint.movie(id: id)
        XCTAssertEqual(sut.path, "/movie/\(id)")
        XCTAssertEqual(sut.method, .get)
        XCTAssertNoThrow(try sut.body())
        XCTAssertNil(try sut.body())
    }
}

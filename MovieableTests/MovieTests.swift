//
//  MovieTests.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/5/20.
//

import XCTest
@testable import Movieable

final class MovieTests: XCTestCase {
    
    func testEmpty() throws {
        let decoder = JSONDecoder()
        let emptyMovie = try decoder.decode(
            Movie.self,
            from:  #"{ "id": -1 }"#.data(using: .utf8)!)
        XCTAssertTrue(emptyMovie.isEmpty)
        
        let movie = try decoder.decode(
            Movie.self,
            from:  #"{ "id": 1 }"#.data(using: .utf8)!)
        XCTAssertFalse(movie.isEmpty)
    }
}

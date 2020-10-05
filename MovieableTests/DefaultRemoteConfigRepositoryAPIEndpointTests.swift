//
//  DefaultRemoteConfigRepositoryAPIEndpointTests.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/5/20.
//

import XCTest
@testable import Movieable

final class DefaultRemoteConfigRepositoryAPIEndpointTests: XCTestCase {
    
    func testConfiguration() throws {
        let sut = DefaultRemoteConfigRepository.APIEndpoint.configuration
        XCTAssertEqual(sut.path, "/configuration")
        XCTAssertEqual(sut.method, .get)
        XCTAssertNoThrow(try sut.body())
        XCTAssertNil(try sut.body())
    }
}

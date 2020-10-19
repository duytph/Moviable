//
//  DefaultAuthorizationMiddlewareTests.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/4/20.
//

import XCTest
import Networkable
@testable import Movieable

final class DefaultAuthorizationMiddlewareTests: XCTestCase {
    
    var sut: DefaultAuthorizationMiddleware!

    override func setUpWithError() throws {
        sut = DefaultAuthorizationMiddleware.defaultValue
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testExample() throws {
        let authorization = sut.authorization()
        XCTAssertEqual(authorization.key, "api_key")
        XCTAssertEqual(authorization.value, Natrium.Config.apiKey)
        XCTAssertEqual(authorization.place, .query)
    }
}

//
//  ResponseErrorTests.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/5/20.
//

import XCTest
@testable import Movieable

final class ResponseErrorTests: XCTestCase {

    var statusMessage: String!
    var sut: ResponseError!
    
    override func setUpWithError() throws {
        statusMessage = "Foo"
        sut = ResponseError(statusMessage: statusMessage)
    }

    override func tearDownWithError() throws {
        statusMessage = nil
        sut = nil
    }
    
    func testErrorDescription() throws {
        XCTAssertEqual(sut.errorDescription, statusMessage)
    }
}

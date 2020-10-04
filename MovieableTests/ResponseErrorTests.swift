//
//  ResponseErrorTests.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/5/20.
//

import XCTest
@testable import Movieable

final class ResponseErrorTests: XCTestCase {

    var statusCode: Int!
    var statusMessage: String!
    var sut: ResponseError!
    
    override func setUpWithError() throws {
        statusCode = 0
        statusMessage = "Foo"
        sut = ResponseError(
            statusCode: statusCode,
            statusMessage: statusMessage)
    }

    override func tearDownWithError() throws {
        statusCode = nil
        statusMessage = nil
        sut = nil
    }
    
    func testErrorDescription() throws {
        XCTAssertEqual(sut.errorDescription, statusMessage)
    }
    
    func testFailureReason() throws {
        XCTAssertEqual(sut.failureReason, statusMessage)
    }
    
    func testRecoverySuggestion() throws {
        XCTAssertEqual(sut.recoverySuggestion, statusMessage)
    }
    
    func testHelpAnchor() throws {
        XCTAssertEqual(sut.helpAnchor, String(statusCode!))
    }
}

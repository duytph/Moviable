//
//  PaginationResponseErrorTests.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/6/20.
//

import XCTest
@testable import Movieable

final class PaginationResponseErrorTests: XCTestCase {
    
    var errors: [String]!
    var sut: PaginationResponseError!
    
    override func setUpWithError() throws {
        errors = ["Foo", "Bar"]
        sut = PaginationResponseError(errors: errors)
    }

    override func tearDownWithError() throws {
        errors = nil
        sut = nil
    }
    
    func testErrorDescription() throws {
        errors.forEach {
            XCTAssertTrue(sut.localizedDescription.contains($0))
        }
    }
}

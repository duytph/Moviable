//
//  DefaultMiddlewaresTests.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/4/20.
//

import XCTest
import Networkable
@testable import Movieable

final class DefaultMiddlewaresTests: XCTestCase {
    
    var sut: [Middleware]!

    override func setUpWithError() throws {
        sut = .defaultValue
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testExample() throws {
        XCTAssertTrue(sut.contains(where: { $0 is LocalizationMiddleware }))
    }
}

//
//  DefaultEndpointHeaderTests.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/4/20.
//

import XCTest
import Networkable
@testable import Movieable

final class DefaultEndpointHeaderTests: XCTestCase {
    
    func testHeaders() {
        let endpoint = StubEndpoint()
        let sut = endpoint.headers
        XCTAssertNotNil(sut)
        XCTAssertTrue(sut!.contains(where: { $0.key == "Accept" && $0.value == "application/json" }))
        XCTAssertTrue(sut!.contains(where: { $0.key == "Content-Type" && $0.value == "application/json" }))
    }
}

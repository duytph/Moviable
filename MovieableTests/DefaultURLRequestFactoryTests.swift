//
//  DefaultURLRequestFactoryTests.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/4/20.
//

import XCTest
import Networkable
@testable import Movieable

final class DefaultURLRequestFactoryTests: XCTestCase {
    
    var sut: URLRequestFactory!
    
    override func setUpWithError() throws {
        sut = DefaultURLRequestFactory.defaultValue
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testBaseURL() throws {
        let endpoint = StubEndpoint()
        endpoint.stubMethod = .get
        endpoint.stubPath = "/foo/bar"
        endpoint.stubBody = "Data".data(using: .utf8)
        let baseURL = Natrium.Config.baseURL
        let request = try sut.make(endpoint: endpoint)
        let url = request.url
        
        XCTAssertNotNil(url)
        XCTAssertTrue(url!.absoluteString.hasPrefix(baseURL))
    }
}

//
//  ResponseErrorMiddlewareTests.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/4/20.
//

import XCTest
@testable import Movieable

final class ResponseErrorMiddlewareTests: XCTestCase {
    
    var responseError: ResponseError!
    var url: URL!
    var request: URLRequest!
    var response: HTTPURLResponse!
    var data: Data!
    var decoder: JSONDecoder!
    var sut: ResponseErrorMiddleware!
    
    override func setUpWithError() throws {
        responseError = ResponseError(statusMessage: "Foo")
        url = URL(string: "https://www.apple.com")
        request = URLRequest(url: url)
        response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)
        data = try JSONEncoder().encode(responseError)
        decoder = JSONDecoder()
        sut = ResponseErrorMiddleware(decoder: decoder)
    }
    
    override func tearDownWithError() throws {
        responseError = nil
        url = nil
        request = nil
        response = nil
        data = nil
        decoder = nil
        sut = nil
    }
    
    func testPrepareRequest() throws {
        XCTAssertNoThrow(try sut.prepare(request: request))
        XCTAssertEqual(try sut.prepare(request: request), request)
    }
    
    func testWillSendRequest() throws {
        XCTAssertNoThrow(sut.willSend(request: request))
    }
    
    func testDidReceiveResponseAndData() {
        XCTAssertThrowsError(
            try sut.didReceive(response: response, data: data),
            "Expect throwing \(ResponseError.self)") { (error: Error) in
            XCTAssertTrue(error is ResponseError)
        }
    }
    
    func testDidReceiveResponseAndDataNotThrowing() {
        XCTAssertNoThrow(try sut.didReceive(response: response, data: "Foo".data(using: .utf8)!))
    }
}

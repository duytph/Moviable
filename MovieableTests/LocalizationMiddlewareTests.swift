//
//  LocalizationMiddlewareTests.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/4/20.
//

import XCTest
import Networking
@testable import Movieable

final class LocalizationMiddlewareTests: XCTestCase {
    
    var url: URL!
    var request: URLRequest!
    var response: URLResponse!
    var data: Data!
    var locale: Locale!
    var languageKey: String!
    var regionKey: String!
    var sut: LocalizationMiddleware!

    override func setUpWithError() throws {
        url = URL(string: "https://apple.com")
        request = URLRequest(url: url)
        response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)
        data = "fizz".data(using: .utf8)!
        locale = Locale(identifier: "en_US")
        languageKey = "foo"
        regionKey = "bar"
        sut = LocalizationMiddleware(
            locale: locale,
            languageKey: languageKey,
            regionKey: regionKey)
    }

    override func tearDownWithError() throws {
        url = nil
        request = nil
        response = nil
        data = nil
        locale = nil
        languageKey = nil
        regionKey = nil
        sut = nil
    }

    func testInit() throws {
        XCTAssertEqual(sut.locale, locale)
        XCTAssertEqual(sut.languageKey, languageKey)
        XCTAssertEqual(sut.regionKey, regionKey)
    }
    
    func testPrepareRequest() throws {
        let languageIdentifier = "\(locale.languageCode!)-\(locale.regionCode!)"
        let languageQuery = "\(languageKey!)=\(languageIdentifier)"
        let regionQuery = "\(regionKey!)=\(locale.regionCode!)"
        let preparedRequest = try sut.prepare(request: request)
        let preparedQuery = preparedRequest.url?.query
        
        XCTAssertNotNil(preparedQuery)
        XCTAssertTrue(preparedQuery!.contains(languageQuery))
        XCTAssertTrue(preparedQuery!.contains(regionQuery))
    }
    
    func testPrepareRequestWhenLocaleIsInvalid() throws {
        let originRequest = request
        locale = Locale(identifier: "")
        sut = LocalizationMiddleware(locale: locale, languageKey: languageKey)
        let preparedRequest = try sut.prepare(request: request)
        
        XCTAssertEqual(originRequest, preparedRequest)
    }
    
    func testPrepareRequestWhenURLIsInvalid() throws {
        request.url = nil
        let originRequest = request
        let preparedRequest = try sut.prepare(request: request)
        
        XCTAssertEqual(originRequest, preparedRequest)
    }
    
    func testWillSendRequest() throws {
        XCTAssertNoThrow(sut.willSend(request: request))
    }
    
    func testDidReceiveResponseAndData() throws {
        XCTAssertNoThrow(try sut.didReceive(response: response, data: data))
    }
}

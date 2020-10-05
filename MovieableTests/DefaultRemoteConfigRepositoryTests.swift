//
//  DefaultRemoteConfigRepositoryTests.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/5/20.
//

import Combine
import XCTest
@testable import Movieable

final class DefaultRemoteConfigRepositoryTests: XCTestCase {
    
    var url: URL!
    var request: URLRequest!
    var response: HTTPURLResponse!
    var data: Data!
    var error: StubError!
    var requestFactory: SpyURLRequestFactory!
    var cancelBag: Set<AnyCancellable>!
    var middlewares: [SpyMiddleware]!
    var session: URLSession!
    var sut: DefaultRemoteConfigRepository!

    override func setUpWithError() throws {
        url = URL(string: "https://www.apple.com")
        request = URLRequest(url: url)
        response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)
        data = #"{ "foo": "bar" }"#.data(using: .utf8)
        error = StubError()
        requestFactory = SpyURLRequestFactory()
        requestFactory.stubbedMakeResult = request
        cancelBag = Set<AnyCancellable>()
        let middleware = SpyMiddleware()
        middleware.stubbedPrepareResult = request
        middlewares = [middleware]
        session = .stubbed
        sut = DefaultRemoteConfigRepository(
            requestFactory: requestFactory,
            middlewares: middlewares,
            session: session)
        
        session.set(stubbedResponse: response, for: request)
    }
    
    override func tearDownWithError() throws {
        session.tearDown()
        url = nil
        request = nil
        response = nil
        data = nil
        error = nil
        requestFactory = nil
        cancelBag = nil
        middlewares = nil
        session = nil
        sut = nil
    }
    
    func testInit() throws {
        XCTAssertTrue(sut.requestFactory is SpyURLRequestFactory)
        XCTAssertEqual(sut.middlewares.count, 1)
        XCTAssertTrue(sut.middlewares.first is SpyMiddleware)
        XCTAssertTrue(sut.session === session)
    }
    
    func testRefreshEncounterError() throws {
        let expectation = self.expectation(description: "Expect configuration is not changed")
        expectation.assertForOverFulfill = true
        expectation.expectedFulfillmentCount = 1
        session.set(stubbedResponseError: error, for: request)
        sut.refresh()
        
        sut
            .configurationPublisher
            .sink { (_) in
                XCTFail(expectation.description)
            } receiveValue: { (_) in
                expectation.fulfill()
            }
            .store(in: &cancelBag)
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testRefreshEncounterDecodingError() throws {
        let expectation = self.expectation(description: "Expect configuration is not changed")
        expectation.assertForOverFulfill = true
        expectation.expectedFulfillmentCount = 1
        session.set(stubbedData: "foo".data(using: .utf8), for: request)
        sut.refresh()
        
        sut
            .configurationPublisher
            .sink { (_) in
                XCTFail(expectation.description)
            } receiveValue: { (_) in
                expectation.fulfill()
            }
            .store(in: &cancelBag)
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testRefresh() throws {
        let expectation = self.expectation(description: "Expect fetched configuration is different to origin")
        let originConfiguration = sut.configuration
        let data = """
        {
          "images": {
            "base_url": "http://image.tmdb.org/t/p/",
            "secure_base_url": "https://image.tmdb.org/t/p/",
            "backdrop_sizes": [],
            "logo_sizes": [],
            "poster_sizes": [],
            "profile_sizes": [],
            "still_sizes": []
          },
        }
        """
            .data(using: .utf8)
        session.set(stubbedData: data, for: request)
        sut.refresh()
        
        sut
            .configurationPublisher
            .sink { (configuration: Configuration) in
                guard originConfiguration != configuration else { return }
                expectation.fulfill()
            }
            .store(in: &cancelBag)
        
        wait(for: [expectation], timeout: 0.5)
    }
}

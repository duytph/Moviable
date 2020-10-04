//
//  DefaultMovieRepositoryTests.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/4/20.
//

import Combine
import XCTest
import Networking
@testable import Movieable

final class DefaultMovieRepositoryTests: XCTestCase {
    
    var rawJSON: String!
    var url: URL!
    var request: URLRequest!
    var response: HTTPURLResponse!
    var data: Data!
    var error: StubError!
    var requestFactory: SpyURLRequestFactory!
    var cancelBag: Set<AnyCancellable>!
    var middlewares: [SpyMiddleware]!
    var session: URLSession!
    var sut: DefaultMovieRepository!

    override func setUpWithError() throws {
        rawJSON = """
        {
          "page": 1,
          "results": [
            {
              "poster_path": "/e1mjopzAS2KNsvpbpahQ1a6SkSn.jpg",
              "adult": false,
              "overview": "From DC Comics comes the Suicide Squad, an antihero team of incarcerated supervillains who act as deniable assets for the United States government, undertaking high-risk black ops missions in exchange for commuted prison sentences.",
              "release_date": "2016-08-03",
              "genre_ids": [
                14,
                28,
                80
              ],
              "id": 297761,
              "original_title": "Suicide Squad",
              "original_language": "en",
              "title": "Suicide Squad",
              "backdrop_path": "/ndlQ2Cuc3cjTL7lTynw6I4boP4S.jpg",
              "popularity": 48.261451,
              "vote_count": 1466,
              "video": false,
              "vote_average": 5.91
            }
          ]
        }
        """
        url = URL(string: "https://www.apple.com")
        request = URLRequest(url: url)
        response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)
        data = rawJSON.data(using: .utf8)
        error = StubError()
        requestFactory = SpyURLRequestFactory()
        requestFactory.stubbedMakeResult = request
        cancelBag = Set<AnyCancellable>()
        let middleware = SpyMiddleware()
        middleware.stubbedPrepareResult = request
        middlewares = [middleware]
        session = .stubbed
        sut = DefaultMovieRepository(
            requestFactory: requestFactory,
            middlewares: middlewares,
            session: session)
        
        session.set(stubbedData: data, for: request)
        session.set(stubbedResponse: response, for: request)
    }

    override func tearDownWithError() throws {
        requestFactory = nil
        middlewares = nil
        session = nil
        sut = nil
    }

    func testPopularAPIEndpoint() throws {
        let page = 0
        let endpoint = DefaultMovieRepository.APIEndpoint.popular(page: page)
        XCTAssertTrue(endpoint.path.contains("page=\(page)"))
        XCTAssertEqual(endpoint.method, .get)
        XCTAssertNil(try endpoint.body())
    }
    
    func testInit() throws {
        XCTAssertTrue(sut.requestFactory is SpyURLRequestFactory)
        XCTAssertEqual(sut.middlewares.count, 1)
        XCTAssertTrue(sut.middlewares.first is SpyMiddleware)
        XCTAssertTrue(sut.session === session)
    }
    
    func testPopularEncounterError() throws {
        let expectation = self.expectation(description: "Expect encountering error")
        session.set(stubbedResponseError: error, for: request)
        
        sut
            .popular(page: 0)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure:
                    expectation.fulfill()
                case .finished:
                    XCTFail(expectation.description)
                }
            }) { (response: PaginationResponse<Movie>) in
                XCTFail(expectation.description)
            }
            .store(in: &cancelBag)
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testPopularEncounterDecodingError() throws {
        let expectation = self.expectation(description: "Expect encountering decoding error")
        session.set(stubbedData: "foo".data(using: .utf8), for: request)
        
        sut
            .popular(page: 0)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case let .failure(error):
                    XCTAssertTrue(error is DecodingError)
                    expectation.fulfill()
                case .finished:
                    XCTFail(expectation.description)
                }
            }) { (response: PaginationResponse<Movie>) in
                XCTFail(expectation.description)
            }
            .store(in: &cancelBag)
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testPopular() throws {
        let expectation = self.expectation(description: "Expect receiving data")
        
        sut
            .popular(page: 0)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure:
                    XCTFail(expectation.description)
                case .finished:
                    break
                }
            }) { (response: PaginationResponse<Movie>) in
                expectation.fulfill()
            }
            .store(in: &cancelBag)
        
        wait(for: [expectation], timeout: 0.5)
    }
}

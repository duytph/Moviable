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
          "total_results": 10000,
          "total_pages": 500,
          "results": [
            {
              "popularity": 2075.72,
              "vote_count": 1439,
              "video": false,
              "poster_path": "/riYInlsq2kf1AWoGm80JQW5dLKp.jpg",
              "id": 497582,
              "adult": false,
              "backdrop_path": "/kMe4TKMDNXTKptQPAdOF0oZHq3V.jpg",
              "original_language": "en",
              "original_title": "Enola Holmes",
              "genre_ids": [
                80,
                18,
                9648
              ],
              "title": "Enola Holmes",
              "vote_average": 7.7,
              "overview": "While searching for her missing mother, intrepid teen Enola Holmes uses her sleuthing skills to outsmart big brother Sherlock and help a runaway lord.",
              "release_date": "2020-09-23"
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
    
    func testMovieEncounterError() throws {
        let expectation = self.expectation(description: "Expect encountering error")
        session.set(stubbedResponseError: error, for: request)
        
        sut
            .movie(id: 0)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure:
                    expectation.fulfill()
                case .finished:
                    XCTFail(expectation.description)
                }
            }) { (_) in
                XCTFail(expectation.description)
            }
            .store(in: &cancelBag)
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testMovieEncounterDecodingError() throws {
        let expectation = self.expectation(description: "Expect encountering decoding error")
        session.set(stubbedData: "foo".data(using: .utf8), for: request)
        
        sut
            .movie(id: 0)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case let .failure(error):
                    XCTAssertTrue(error is DecodingError)
                    expectation.fulfill()
                case .finished:
                    XCTFail(expectation.description)
                }
            }) { (_) in
                XCTFail(expectation.description)
            }
            .store(in: &cancelBag)
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testMovie() throws {
        let expectation = self.expectation(description: "Expect receiving data")
        
        sut
            .movie(id: 0)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure:
                    XCTFail(expectation.description)
                case .finished:
                    break
                }
            }) { (_) in
                expectation.fulfill()
            }
            .store(in: &cancelBag)
        
        wait(for: [expectation], timeout: 0.5)
    }
}

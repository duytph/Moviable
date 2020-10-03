//
//  LoadableTests.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/3/20.
//

import XCTest
@testable import Movieable

final class LoadableTests: XCTestCase {
    
    var loadingLastValue: Int!
    var loadedValue: Int!
    var failedError: StubError!
    
    override func setUpWithError() throws {
        loadingLastValue = 0
        loadedValue = 0
        failedError = StubError()
        
        continueAfterFailure = true
    }
    
    override func tearDownWithError() throws {
        loadingLastValue = nil
        loadedValue = nil
        failedError = nil
    }
    
    func testValue() throws {
        let allCases: [Loadable<Int>] = [
            .idle,
            .isLoading(last: nil),
            .isLoading(last: loadingLastValue),
            .loaded(loadedValue),
            .failed(failedError)
        ]
        
        let results = allCases.map { $0.value }
        
        let expectedResults: [Int?] = [
            nil,
            nil,
            loadingLastValue,
            loadedValue,
            nil,
        ]
        
        XCTAssertEqual(results, expectedResults)
    }
    
    func testErrorWhenCaseHavingNoError() throws {
        let allCases: [Loadable<Int>] = [
            .idle,
            .isLoading(last: nil),
            .isLoading(last: loadingLastValue),
            .loaded(loadedValue),
        ]
        
        let results = allCases.compactMap { $0.error }
        XCTAssertTrue(results.isEmpty)
    }
    
    func testErrorWhenCaseHavingError() throws {
        XCTAssertEqual(
            Loadable<Int>.failed(failedError).error as? StubError,
            failedError)
    }
    
    func testEqual() throws {
        typealias Pair = (Loadable<Int>, Loadable<Int>)
        typealias TestCase = (Pair, Bool)
        
        let testCases: [TestCase] = [
            ((.idle, .idle), true),
            ((.idle, .isLoading(last: nil)), false),
            ((.idle, .isLoading(last: 0)), false),
            ((.idle, .loaded(0)), false),
            ((.idle, .failed(failedError)), false),
            
            ((.isLoading(last: nil), .isLoading(last: nil)), true),
            ((.isLoading(last: nil), .isLoading(last: 0)), false),
            ((.isLoading(last: 0), .isLoading(last: 0)), true),
            ((.isLoading(last: 0), .isLoading(last: nil)), false),
            ((.isLoading(last: nil), .loaded(0)), false),
            ((.isLoading(last: nil), .failed(failedError)), false),
            ((.isLoading(last: 0), .loaded(0)), false),
            ((.isLoading(last: 0), .failed(failedError)), false),
            
            ((.loaded(0), .loaded(0)), true),
            ((.loaded(0), .loaded(1)), false),
            ((.loaded(1), .loaded(0)), false),
            ((.loaded(0), .failed(failedError)), false),
            
            ((.failed(failedError), .failed(failedError)), true),
            ((.failed(failedError), .failed(StubError(stubErrorDescription: "Foo"))), false),
        ]
        
        testCases.forEach { (testCase: TestCase) in
            let (pair, result) = testCase
            let isEqual = pair.0 == pair.1
            XCTAssertEqual(isEqual, result)
        }
    }
}

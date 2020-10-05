//
//  DecimalNumberFormatterTests.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/5/20.
//

import XCTest
@testable import Movieable

final class DecimalNumberFormatterTests: XCTestCase {

    var sut: NumberFormatter!
    
    override func setUpWithError() throws {
        continueAfterFailure = true
        
        sut = .decimal
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testNumberFromString() throws {
        XCTAssertEqual(sut.number(from: "0")?.intValue, 0)
        
        XCTAssertEqual(sut.number(from: "010")?.intValue, 10)
        
        XCTAssertEqual(sut.number(from: "-101")?.intValue, -101)
        
        XCTAssertEqual(sut.number(from: "1.23")?.intValue, 1)
        
        XCTAssertNil(sut.number(from: ""))
        
        XCTAssertNil(sut.number(from: "a123"))
        
        XCTAssertNil(sut.number(from: "23%"))
    }
    
    func testStringFromNumber() {
        XCTAssertEqual(sut.string(from: NSNumber(value: 0)), "0")
        
        XCTAssertEqual(sut.string(from: NSNumber(value: -123)), "-123")
        
        XCTAssertEqual(sut.string(from: NSNumber(value: 1.23)), "1")
        
        XCTAssertEqual(sut.string(from: NSNumber(value: -0.43145)), "-0")
        
        XCTAssertEqual(sut.string(from: NSNumber(value: 0.43145)), "0")
    }
}

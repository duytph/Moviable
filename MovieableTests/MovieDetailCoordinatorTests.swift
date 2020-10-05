//
//  MovieDetailCoordinatorTests.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/5/20.
//

import XCTest
@testable import Movieable

final class MovieDetailCoordinatorTests: XCTestCase {
    
    var url: URL!
    var children: [Coordinator]!
    var navigationController: UINavigationController!
    var sut: MockMovieDetailCoordinator!

    override func setUpWithError() throws {
        url = URL(string: "https://9gag.com")!
        children = []
        navigationController = UINavigationController()
        sut = MockMovieDetailCoordinator(children: children, navigationController: navigationController)
    }

    override func tearDownWithError() throws {
        url = nil
        children = nil
        navigationController = nil
        sut = nil
    }

    func testExample() throws {
        XCTAssertNil(sut.navigationController.presentedViewController)
        sut.open(url: url, animated: false) {
            XCTAssertNotNil(self.sut.navigationController.presentedViewController)
        }
    }
}

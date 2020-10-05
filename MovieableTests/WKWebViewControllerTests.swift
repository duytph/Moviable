//
//  WKWebViewControllerTests.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/5/20.
//

import UIKit
import XCTest
import WebKit
@testable import Movieable

final class WKWebViewControllerTests: XCTestCase {

    var url: URL!
    var request: URLRequest!
    var sut: WKWebViewController!
    
    override func setUpWithError() throws {
        url = URL(string: "https://9gag.com")!
        request = URLRequest(url: url)
        sut = WKWebViewController(request: request)
    }

    override func tearDownWithError() throws {
        url = nil
        request = nil
        sut = nil
    }

    func testViewDidLoad() throws {
        sut.loadViewIfNeeded()
        XCTAssertNotNil(sut.estimatedProgressObservation)
        XCTAssertTrue(sut.webView.isLoading)
    }
    
    func testViewWillAppearWhenItIsRootViewController() throws {
        let _ = UINavigationController(rootViewController: sut)
        sut.viewWillAppear(false)
        XCTAssertNotNil(sut.navigationItem.leftBarButtonItem)
    }
    
    func testViewWillAppearWhenItIsNotRootViewController() throws {
        let navigationController = UINavigationController()
        navigationController.setViewControllers([UIViewController(), sut], animated: false)
        sut.viewWillAppear(false)
        XCTAssertNil(sut.navigationItem.leftBarButtonItem)
    }
    
    func testMakeNavigationActionDecision() throws {
        let expectation = self.expectation(description: "Expect action always is allowed")
        
        let handler = { (policy: WKNavigationActionPolicy) in
            guard policy == .allow else {
                XCTFail(expectation.expectationDescription)
                return
            }
            expectation.fulfill()
        }
        
        sut.webView(
            sut.webView,
            decidePolicyFor: WKNavigationAction(),
            decisionHandler: handler)
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testMakeNavigationResponseDecision() throws {
        let expectation = self.expectation(description: "Expect action always is allowed")
        
        let handler = { (policy: WKNavigationResponsePolicy) in
            guard policy == .allow else {
                XCTFail(expectation.expectationDescription)
                return
            }
            expectation.fulfill()
        }
        
        sut.webView(
            sut.webView,
            decidePolicyFor: WKNavigationResponse(),
            decisionHandler: handler)
        
        wait(for: [expectation], timeout: 0.5)
    }
}

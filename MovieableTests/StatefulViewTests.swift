//
//  StatefulViewTests.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/3/20.
//

import XCTest
@testable import Movieable

final class StatefulViewTests: XCTestCase {
    
    var padding: CGFloat!
    var action: (() -> Void)!
    var title: String!
    var image: UIImage!
    var actionTitle: String!
    var sut: StatefulView!

    override func setUpWithError() throws {
        padding = 16
        action = {}
        title = "Foo"
        image = Asset.launchScreen.image
        actionTitle = "Bar"
        
        sut = StatefulView(
            padding: padding,
            action: action)
    }

    override func tearDownWithError() throws {
        padding = nil
        action = nil
        sut = nil
    }
    
    func testInit() {
        let mainButtonActions = sut.actionButton.actions(
            forTarget: sut,
            forControlEvent: .touchUpInside)
        
        XCTAssertEqual(sut.padding, padding)
        XCTAssertNotNil(sut.action)
        XCTAssertTrue(sut.titleLabel.isDescendant(of: sut))
        XCTAssertTrue(sut.imageView.isDescendant(of: sut))
        XCTAssertTrue(sut.actionButton.isDescendant(of: sut))
        XCTAssertTrue(sut.stackView.isDescendant(of: sut))
        XCTAssertTrue(!mainButtonActions!.isEmpty)
    }
    
    func testConfigure() {
        sut.titleLabel.text = nil
        sut.imageView.image = nil
        sut.actionButton.setTitle(nil, for: .normal)
        sut.action = nil
        
        sut.configure(
            withTitle: title,
            image: image,
            actionTitle: actionTitle,
            action: action)
        
        XCTAssertEqual(sut.titleLabel.text, title)
        XCTAssertEqual(sut.imageView.image, image)
        XCTAssertEqual(sut.actionButton.title(for: .normal), actionTitle)
        XCTAssertNotNil(sut.action)
    }
    
    func testStaticLoading() throws {
        let loading = StatefulView.loading(
            padding: padding,
            title: title,
            image: image,
            actionTitle: actionTitle,
            action: {})
        
        XCTAssertEqual(loading.padding, padding)
        XCTAssertNotNil(loading.action)
        XCTAssertEqual(loading.titleLabel.text, title)
        XCTAssertEqual(loading.imageView.image, image)
        XCTAssertEqual(loading.actionButton.title(for: .normal), actionTitle)
    }
    
    func testStaticEmpty() throws {
        let loading = StatefulView.empty(
            padding: padding,
            title: title,
            image: image,
            actionTitle: actionTitle,
            action: {})
        
        XCTAssertEqual(loading.padding, padding)
        XCTAssertNotNil(loading.action)
        XCTAssertEqual(loading.titleLabel.text, title)
        XCTAssertEqual(loading.imageView.image, image)
        XCTAssertEqual(loading.actionButton.title(for: .normal), actionTitle)
    }
    
    func testStaticError() throws {
        let loading = StatefulView.error(
            padding: padding,
            title: title,
            image: image,
            actionTitle: actionTitle,
            action: {})
        
        XCTAssertEqual(loading.padding, padding)
        XCTAssertNotNil(loading.action)
        XCTAssertEqual(loading.titleLabel.text, title)
        XCTAssertEqual(loading.imageView.image, image)
        XCTAssertEqual(loading.actionButton.title(for: .normal), actionTitle)
    }
}

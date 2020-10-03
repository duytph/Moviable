//
//  StateMachineTests.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/3/20.
//

import XCTest
@testable import Movieable

final class StateMachineTests: XCTestCase {
    
    var provider: SpyStateMachineViewProvider!
    var sut: DefaultStateMachine<[Int]>!

    override func setUpWithError() throws {
        provider = SpyStateMachineViewProvider()
        provider.stubbedParentView = UIView()
        provider.stubbedConstrainedTargetView = UIView()
        provider.stubbedContentView = UIView()
        provider.stubbedLoadingViewResult = UIView()
        provider.stubbedEmtyViewResult = UIView()
        provider.stubbedErrorViewResult = UIView()
        provider.stubbedParentView.addSubview(provider.stubbedConstrainedTargetView)
        
        sut = DefaultStateMachine()
    }

    override func tearDownWithError() throws {
        provider = nil
        sut = nil
    }
    
    func testPresentStateWhenStateIsIdle() throws {
        let view = provider.contentView
        let parentView = provider.parentView
        
        XCTAssertFalse(view.isDescendant(of: parentView))
        sut.present(state: .idle, provider: provider)
        XCTAssertTrue(view.isDescendant(of: parentView))
        XCTAssertEqual(parentView.subviews.last, view)
    }
    
    func testPresentStateWhenStateIsLoadingWithLastItem() throws {
        let view = provider.contentView
        let parentView = provider.parentView
        
        XCTAssertFalse(view.isDescendant(of: parentView))
        sut.present(state: .isLoading(last: [0]), provider: provider)
        XCTAssertTrue(view.isDescendant(of: parentView))
        XCTAssertEqual(parentView.subviews.last, view)
    }
    
    func testPresentStateWhenStateIsLoadingWithoutLastItem() throws {
        let view = provider.loadingView()
        let parentView = provider.parentView
        
        XCTAssertFalse(view.isDescendant(of: parentView))
        sut.present(state: .isLoading(last: nil), provider: provider)
        XCTAssertTrue(view.isDescendant(of: parentView))
        XCTAssertEqual(parentView.subviews.last, view)
    }
    
    func testPresentStateWhenStateIsLoadedWithEmptyItem() throws {
        let view = provider.emptyView()
        let parentView = provider.parentView
        
        XCTAssertFalse(view.isDescendant(of: parentView))
        sut.present(state: .loaded([]), provider: provider)
        XCTAssertTrue(view.isDescendant(of: parentView))
        XCTAssertEqual(parentView.subviews.last, view)
    }
    
    func testPresentStateWhenStateIsLoadedWithItem() throws {
        let view = provider.contentView
        let parentView = provider.parentView
        
        XCTAssertFalse(view.isDescendant(of: parentView))
        sut.present(state: .loaded([0]), provider: provider)
        XCTAssertTrue(view.isDescendant(of: parentView))
        XCTAssertEqual(parentView.subviews.last, view)
    }
    
    func testPresentStateWhenStateIsFailed() throws {
        let error = StubError()
        let view = provider.errorView(error: error)
        let parentView = provider.parentView
        
        XCTAssertFalse(view.isDescendant(of: parentView))
        sut.present(state: .failed(error), provider: provider)
        XCTAssertTrue(view.isDescendant(of: parentView))
        XCTAssertEqual(parentView.subviews.last, view)
    }
    
    func testPresentView() throws {
        let view = UIView()
        let parentView = UIView()
        let constrainedTargetView = UIView()
        
        parentView.addSubview(constrainedTargetView)
        
        sut.present(
            view: view,
            parentView: parentView,
            constrainedTargetView: constrainedTargetView)
        
        let constrained = view
            .constraints
            .flatMap { (constraint: NSLayoutConstraint) in
                [constraint.firstItem, constraint.secondItem]
            }
            .allSatisfy { $0 === view || $0 === constrainedTargetView }
        
        XCTAssertTrue(!view.translatesAutoresizingMaskIntoConstraints)
        XCTAssertTrue(view.isDescendant(of: parentView))
        XCTAssertTrue(constrained)
    }
    
    func testPresentViewWhenViewIsDescendantofParentViewAldready() throws {
        let view = UIView()
        let parentView = UIView()
        let constrainedTargetView = UIView()
        
        parentView.addSubview(view)
        parentView.addSubview(constrainedTargetView)
        
        sut.present(
            view: view,
            parentView: parentView,
            constrainedTargetView: constrainedTargetView)
        
        XCTAssertEqual(parentView.subviews.last, view)
    }
}

//
//  MoviesListViewControllerTests.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/5/20.
//

import XCTest
@testable import Movieable

final class MoviesListViewControllerTests: XCTestCase {
    
    var movie: Movie!
    var error: StubError!
    var viewModel: SpyMoviesListViewModel!
    var stateMachine: SpyStateMachine<[Movie]>!
    var anyStateMachine: AnyStateMachine<[Movie]>!
    var sut: MoviesListViewController!

    override func setUpWithError() throws {
        movie = .mock
        error = StubError()
        viewModel = SpyMoviesListViewModel()
        stateMachine = SpyStateMachine()
        anyStateMachine = stateMachine.eraseToAnyStateMachine()
        sut = MoviesListViewController(
            viewModel: viewModel,
            stateMachine: anyStateMachine)
    }

    override func tearDownWithError() throws {
        movie = nil
        error = nil
        viewModel = nil
        stateMachine = nil
        sut = nil
    }

    func testViewDidLoad() throws {
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.tableView.isDescendant(of: sut.view))
        XCTAssertTrue(viewModel.invokedViewDidLoad)
    }
    
    func testPresentState() throws {
        let states: [Loadable<[Movie]>] = [
            .idle,
            .isLoading(last: nil),
            .isLoading(last: [movie]),
            .loaded([]),
            .loaded([movie]),
            .failed(error)
        ]
        
        states.forEach {
            sut.present(state: $0)
            XCTAssertTrue(stateMachine.invokedPresent)
            XCTAssertEqual(stateMachine.invokedPresentParameters?.state, $0)
        }
    }
    
    func testEndRefreshing() throws {
        sut.refreshControl.beginRefreshing()
        XCTAssertTrue(sut.refreshControl.isRefreshing)
        sut.endRefreshing()
        XCTAssertFalse(sut.refreshControl.isRefreshing)
    }
    
    func testRefreshControlDidChangeValue() throws {
        sut.refreshControlDidChangeValue(sender: sut.refreshControl)
        XCTAssertTrue(viewModel.invokedRefresh)
    }
    
    func testScrollViewDidScroll() throws {
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: 100, height: 100)
        scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: false)
        sut.scrollViewDidScroll(scrollView)
        XCTAssertTrue(viewModel.invokedLoadMore)
    }
    
    func testDidSelect() throws {
        let indexPath = IndexPath(row: 0, section: 0)
        sut.present(state: .loaded([movie]))
        sut.tableView(sut.tableView, didSelectRowAt: indexPath)
        XCTAssertTrue(viewModel.invokedDidSelect)
    }
    
    func testDidSelectWhenMoviesIsEmpty() throws {
        let indexPath = IndexPath(row: 0, section: 0)
        sut.tableView(sut.tableView, didSelectRowAt: indexPath)
        XCTAssertFalse(viewModel.invokedDidSelect)
    }
}

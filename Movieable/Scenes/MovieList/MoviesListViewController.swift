//
//  MoviesListViewController.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import Combine
import Reusable
import UIKit

protocol MoviesListViewModel: AnyObject {
    
    var presenter: MoviesListPresentable? { get set }
    
    func viewDidLoad()
    func refresh()
    func loadMore()
    func didSelect(movie: Movie)
}

final class MoviesListViewController: UIViewController, MoviesListPresentable {
    
    // MARK: - UIs
    
    private(set) lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(refreshControlDidChangeValue(sender:)),
            for: .valueChanged)
        refreshControl.tintColor = Asset.accentColor.color
        return refreshControl
    }()
    
    private(set) lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .white
        view.allowsMultipleSelection = false
        view.dataSource = self
        view.delegate = self
        view.tableFooterView = UIView()
        view.separatorStyle = .none
        view.refreshControl = refreshControl
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(cellType: MovieTableViewCell.self)
        return view
    }()
    
    private(set) lazy var statefulLoadingView = StatefulView.loading()
    
    private(set) lazy var statefulErrorView = StatefulView.error(action: { [weak viewModel] in
        viewModel?.refresh()
    })
    
    private(set) lazy var statefulEmptyView = StatefulView.empty(action: { [weak viewModel] in
        viewModel?.refresh()
    })
    
    // MARK: - Dependencies
    
    let viewModel: MoviesListViewModel
    let stateMachine: AnyStateMachine<[Movie]>
    
    private var movies: [Movie] = []
    
    // MARK: - Init
    
    init(
        viewModel: MoviesListViewModel = PopularMoviesViewModel(),
        stateMachine: AnyStateMachine<[Movie]> = DefaultStateMachine().eraseToAnyStateMachine()) {
        self.viewModel = viewModel
        self.stateMachine = stateMachine
        super.init(nibName: nil, bundle: nil)
        self.viewModel.presenter = self
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = PopularMoviesViewModel()
        self.stateMachine = DefaultStateMachine().eraseToAnyStateMachine()
        super.init(coder: coder)
        self.viewModel.presenter = self
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.viewDidLoad()
    }
    
    // MARK: - MoviesListPresentable
    
    func present(state: Loadable<[Movie]>) {
        stateMachine.present(state: state, provider: self)
        guard let value = state.value else { return }
        movies = value
        tableView.reloadData()
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    // MARK: - Private
    
    @objc private func refreshControlDidChangeValue(sender: UIRefreshControl) {
        viewModel.refresh()
    }
}

// MARK: - UITableViewDataSource

extension MoviesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MovieTableViewCell.self)
        let movie = movies[indexPath.row]
        cell.configure(withMovie: movie)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MoviesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard
            indexPath.row < movies.count,
            indexPath.row >= 0
        else { return }
        let movie = movies[indexPath.row]
        viewModel.didSelect(movie: movie)
    }
}

extension MoviesListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        guard offset > 0 else { return }
        
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        let buffer = CGFloat(300)
        let distanceFromBottom = contentHeight - frameHeight - buffer
        
        guard scrollView.contentOffset.y >= distanceFromBottom else { return }
        viewModel.loadMore()
    }
}

// MARK: - StateMachineViewProvider

extension MoviesListViewController: StateMachineViewProvider {
    
    var parentView: UIView {
        view
    }
    
    var constrainedTargetView: UIView {
        view
    }
    
    var contentView: UIView {
        tableView
    }
    
    func emptyView() -> UIView {
        statefulEmptyView
    }
    
    func loadingView() -> UIView {
        statefulLoadingView
    }
    
    func errorView(error: Error) -> UIView {
        statefulErrorView.titleLabel.text = error.localizedDescription
        return statefulErrorView
    }
}

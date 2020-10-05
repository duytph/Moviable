//
//  MovieDetailViewController.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import Kingfisher
import UIKit

protocol MovieDetailViewModel: AnyObject {
    
    var presenter: MovieDetailPresentable? { get set }
    
    func viewDidLoad()
    func refresh()
    func bookButtonDidTap()
}

final class MovieDetailViewController: UIViewController, MovieDetailPresentable {
    
    // MARK: - UIs
    
    @IBOutlet private(set) weak var imageView: UIImageView!
    @IBOutlet private(set) weak var titleLabel: UILabel!
    @IBOutlet private(set) weak var originLanguageLabel: UILabel!
    @IBOutlet private(set) weak var genresLabel: UILabel!
    @IBOutlet private(set) weak var spokenLanguagesLabel: UILabel!
    @IBOutlet private(set) weak var bookButton: UIButton!
    @IBOutlet private(set) weak var scrollView: UIScrollView!
    @IBOutlet weak var overviewLabel: UILabel!
    
    private(set) lazy var statefulLoadingView = StatefulView.loading()
    
    private(set) lazy var statefulErrorView = StatefulView.error(action: { [weak viewModel] in
        viewModel?.refresh()
    })
    
    private(set) lazy var statefulEmptyView = StatefulView.empty(action: { [weak viewModel] in
        viewModel?.refresh()
    })
    
    // MARK: - Dependencies
    
    let viewModel: MovieDetailViewModel
    let stateMachine: AnyStateMachine<Movie>
    let imageURLFactory: ImageURLFactory
    
    // MARK: - Init
    
    init(
        viewModel: MovieDetailViewModel,
        stateMachine: AnyStateMachine<Movie> = DefaultStateMachine().eraseToAnyStateMachine(),
        imageURLFactory: ImageURLFactory = DefaultImageURLFactory.shared) {
        self.viewModel = viewModel
        self.stateMachine = stateMachine
        self.imageURLFactory = imageURLFactory
        super.init(nibName: String(describing: Self.self), bundle: .main)
        self.viewModel.presenter = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.viewDidLoad()
        
        bookButton.layer.masksToBounds = true
        bookButton.layer.cornerRadius = 8
    }
    
    // MARK: - MovieDetailPresentable
    
    func present(state: Loadable<Movie>) {
        stateMachine.present(state: state, provider: self)
        guard let movie = state.value else { return }
        configure(withMovie: movie)
    }
    
    // MARK: - Public
    
    func configure(withMovie movie: Movie) {
        let url = movie.backdropPath.flatMap {
            imageURLFactory.make(
                isSecure: true,
                imageSize: .original,
                in: \Images.backdropSizes,
                path: $0)
        }
        imageView.kf.setImage(with: url, placeholder: Asset.placeholder.image)
        titleLabel.text = movie.title
        let geners = movie
            .genres?
            .compactMap { $0.name }
            .joined(separator: ", ")
        genresLabel.text =  geners.map { NSLocalizedString("Geners", comment: "") + ": " + $0 }
        originLanguageLabel.text = movie.originalLanguage.map { NSLocalizedString("Origin language", comment: "") + ": " + $0 }
        let spokenLanguages = movie
            .spokenLanguages?
            .compactMap { $0.name }
            .joined(separator: ", ")
        spokenLanguagesLabel.text = spokenLanguages.map { NSLocalizedString("Spoken languages", comment: "") + ": " + $0 }
        overviewLabel.text = movie.overview
    }
    
    // MARK: - Private
    
    @IBAction func bookButtonDidTap(_ sender: Any) {
        viewModel.bookButtonDidTap()
    }
}

extension MovieDetailViewController: StateMachineViewProvider {
    
    var parentView: UIView {
        view
    }
    
    var constrainedTargetView: UIView {
        view
    }
    
    var contentView: UIView {
        scrollView
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


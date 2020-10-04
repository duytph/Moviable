//
//  MovieDetailViewController.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import UIKit

protocol MovieDetailViewModel: AnyObject {
    
    var presenter: MovieDetailPresentable? { get set }
    
    func viewDidLoad()
}

final class MovieDetailViewController: UIViewController, MovieDetailPresentable {
    
    // MARK: - Dependencies
    
    let viewModel: MovieDetailViewModel
    
    // MARK: - Init
    
    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
    }
}

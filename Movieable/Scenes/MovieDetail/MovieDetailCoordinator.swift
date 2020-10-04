//
//  MovieDetailCoordinator.swift
//  Movieable
//
//  Created by Duy Tran on 10/5/20.
//

import UIKit

protocol MovieDetailCoordinator: Coordinator {

    func open(url: URL)
}

extension MovieDetailCoordinator {
    
    func open(url: URL) {
        let request = URLRequest(url: url)
        let viewController = WKWebViewController(request: request)
        let webNavigationController = UINavigationController(rootViewController: viewController)
        navigationController.present(webNavigationController, animated: true, completion: nil)
    }
}

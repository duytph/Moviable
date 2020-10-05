//
//  MovieDetailCoordinator.swift
//  Movieable
//
//  Created by Duy Tran on 10/5/20.
//

import UIKit

protocol MovieDetailCoordinator: Coordinator {

    func open(
        url: URL,
        animated: Bool,
        completion: (() -> Void)?)
}

extension MovieDetailCoordinator {
    
    func open(
        url: URL,
        animated: Bool,
        completion: (() -> Void)?) {
        let request = URLRequest(url: url)
        let viewController = WKWebViewController(request: request)
        let webNavigationController = UINavigationController(rootViewController: viewController)
        navigationController.present(
            webNavigationController,
            animated: animated,
            completion: completion)
    }
}

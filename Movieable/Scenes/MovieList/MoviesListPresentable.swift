//
//  MoviesListPresentable.swift
//  Movieable
//
//  Created by Duy Tran on 10/5/20.
//

import Foundation

protocol MoviesListPresentable: AnyObject {
    
    var title: String? { get set }
    
    func present(state: Loadable<[Movie]>)
    func endRefreshing()
}

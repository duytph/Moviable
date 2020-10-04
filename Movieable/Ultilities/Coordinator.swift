//
//  Coordinator.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import UIKit

protocol Coordinator: AnyObject {
    
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get }
    
    func start()
    func add(child: Coordinator)
}

extension Coordinator {
    
    func add(child: Coordinator) {
        children.append(child)
        child.start()
    }
}

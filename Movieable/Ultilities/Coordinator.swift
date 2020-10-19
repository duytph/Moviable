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
    func stop()
    func add(child: Coordinator)
    func remove(child: Coordinator)
}

extension Coordinator {
    
    func add(child: Coordinator) {
        children.append(child)
        child.start()
    }
    
    func remove(child: Coordinator) {
        children.removeAll(where: { $0 === child })
        child.stop()
    }
}

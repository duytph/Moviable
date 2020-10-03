//
//  Emptiable.swift
//  Movieable
//
//  Created by Duy Tran on 10/3/20.
//

import Foundation

protocol Emptiable {
    
    var isEmpty: Bool { get }
}

extension Array: Emptiable {}

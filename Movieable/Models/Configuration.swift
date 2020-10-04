//
//  Configuration.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import Foundation

struct Configuration: Codable, Equatable, Hashable {
    
    let images: Images
}

extension Configuration {
    
    static var defaultValue: Configuration {
        Configuration(images: .defaultValue)
    }
}

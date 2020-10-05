//
//  PaginationResponseError.swift
//  Movieable
//
//  Created by Duy Tran on 10/6/20.
//

import Foundation

struct PaginationResponseError: Codable, LocalizedError {
    
    let errors: [String]
    
    var errorDescription: String? {
        errors.joined(separator: "\n")
    }
}

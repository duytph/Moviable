//
//  PaginationResponse.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import Foundation

struct PaginationResponse<T: Codable>: Codable {
    
    let page: Int
    let results: [T]
}

extension PaginationResponse: Equatable where T: Equatable {}

extension PaginationResponse: Hashable where T: Hashable {}

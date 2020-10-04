//
//  PaginationResponse.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import Foundation

struct PaginationResponse<T: Codable>: Codable {
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
    
    let page, totalResults, totalPages: Int
    let results: [T]
}

extension PaginationResponse: Equatable where T: Equatable {}

extension PaginationResponse: Hashable where T: Hashable {}

//
//  ResponseError.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import Foundation

struct ResponseError: Codable, Hashable, Equatable, LocalizedError {
    
    enum CodingKeys: String, CodingKey {
        case statusMessage = "status_message"
    }
    
    let statusMessage: String
    
    var errorDescription: String? { statusMessage }
}

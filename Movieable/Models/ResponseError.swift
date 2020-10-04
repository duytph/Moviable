//
//  ResponseError.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import Foundation

struct ResponseError: Codable, Hashable, Equatable, LocalizedError {
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
    
    let statusCode: Int
    let statusMessage: String
    
    var errorDescription: String? { statusMessage }

    var failureReason: String? { statusMessage }

    var recoverySuggestion: String? { statusMessage }

    var helpAnchor: String? { String(statusCode) }
}

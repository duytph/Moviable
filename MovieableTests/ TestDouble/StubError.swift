//
//  StubError.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/3/20.
//

import Foundation

struct StubError: LocalizedError, Equatable {
    
    var stubErrorDescription: String?
    var errorDescription: String? {
        stubErrorDescription
    }
    
    var stubFailureReason: String?
    var failureReason: String? {
        stubFailureReason
    }
    
    var stubRecoverySuggestion: String?
    var recoverySuggestion: String? {
        stubRecoverySuggestion
    }
    
    var stubHelpAnchor: String?
    var helpAnchor: String? {
        stubHelpAnchor
    }
}

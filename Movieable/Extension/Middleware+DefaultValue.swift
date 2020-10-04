//
//  Middleware+DefaultValue.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import Foundation
import Networking

extension Array where Element == Networking.Middleware {
    
    static var defaultValue: [Networking.Middleware] {
        [
            LocalizationMiddleware(),
            DefaultLoggingMiddleware(),
            DefaultCodeValidationMiddleware(),
        ]
    }
}

//
//  Middleware+DefaultValue.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import Foundation
import Networkable

extension Array where Element == Networkable.Middleware {
    
    static var defaultValue: [Networkable.Middleware] {
        [
            LoggingMiddleware(),
            LocalizationMiddleware(),
            AuthorizationMiddleware.defaultValue,
            ResponseErrorMiddleware(),
            StatusCodeValidationMiddleware(),
        ]
    }
}

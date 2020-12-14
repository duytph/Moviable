//
//  DefaultAuthorizationMiddleware+DefaultValue.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import Foundation
import Networkable

extension AuthorizationMiddleware {
    
    static var defaultValue: Self {
        AuthorizationMiddleware(
            key: "api_key",
            value: Natrium.Config.apiKey,
            place: .query)
    }
}

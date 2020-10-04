//
//  DefaultAuthorizationMiddleware+DefaultValue.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import Foundation
import Networking

extension Networking.DefaultAuthorizationMiddleware {
    
    static var defaultValue: Self {
        Networking.DefaultAuthorizationMiddleware { () -> Networking.AuthorizationType in
            Networking.DefaultAuthorizationType(
                key: "api_key",
                value: Natrium.Config.apiKey,
                place: .query)
        }
    }
}

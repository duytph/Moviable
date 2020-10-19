//
//  DefaultAuthorizationMiddleware+DefaultValue.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import Foundation
import Networkable

extension Networkable.DefaultAuthorizationMiddleware {
    
    static var defaultValue: Self {
        Networkable.DefaultAuthorizationMiddleware { () -> Networkable.AuthorizationType in
            Networkable.DefaultAuthorizationType(
                key: "api_key",
                value: Natrium.Config.apiKey,
                place: .query)
        }
    }
}

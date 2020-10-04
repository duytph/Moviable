//
//  Endpoint+DefaultHeaders.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import Foundation
import Networking

extension Networking.Endpoint {
    
    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
}

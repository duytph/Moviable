//
//  DefaultURLRequestFactory+DefaultValue.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import Foundation
import Networking

extension Networking.DefaultURLRequestFactory {
    
    static var defaultValue: URLRequestFactory {
        Networking.DefaultURLRequestFactory(host: Natrium.Config.baseURL)
    }
}

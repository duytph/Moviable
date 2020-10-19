//
//  DefaultURLRequestFactory+DefaultValue.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import Foundation
import Networkable

extension Networkable.DefaultURLRequestFactory {
    
    static var defaultValue: URLRequestFactory {
        Networkable.DefaultURLRequestFactory(baseURL: Natrium.Config.baseURL)
    }
}

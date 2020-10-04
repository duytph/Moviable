//
//  StubEndpoint.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/4/20.
//

import Foundation
import Networking
@testable import Movieable

final class StubEndpoint: Networking.Endpoint {
    
    var stubPath: String!
    var path: String { stubPath }
    
    var stubMethod: Networking.Method!
    var method: Networking.Method { stubMethod }
    
    var stubBody: Data!
    func body() throws -> Data? { stubBody }
}

//
//  StubEndpoint.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/4/20.
//

import Foundation
import Networkable
@testable import Movieable

final class StubEndpoint: Networkable.Endpoint {
    
    var stubPath: String!
    var path: String { stubPath }
    
    var stubMethod: Networkable.Method!
    var method: Networkable.Method { stubMethod }
    
    var stubBody: Data!
    func body() throws -> Data? { stubBody }
}

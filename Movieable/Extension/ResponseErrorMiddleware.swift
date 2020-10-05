//
//  ResponseErrorMiddleware.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import Foundation
import Networking

struct ResponseErrorMiddleware: Middleware {
    
    let decoder: JSONDecoder
    
    init(decoder: JSONDecoder = .init()) {
        self.decoder = decoder
    }
    
    func prepare(request: URLRequest) throws -> URLRequest {
        return request
    }
    
    func willSend(request: URLRequest) {}
    
    func didReceive(response: URLResponse, data: Data) throws {
        if let responseError = try? decoder.decode(ResponseError.self, from: data) {
            throw responseError
        } else if let paginationResponseError = try? decoder.decode(PaginationResponseError.self, from: data) {
            throw paginationResponseError
        }
    }
}

//
//  LocalizationMiddleware.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import Foundation
import Networkable

struct LocalizationMiddleware: Networkable.Middleware {
    
    let locale: Locale
    let languageKey: String
    let regionKey: String
    
    init(
        locale: Locale = .autoupdatingCurrent,
        languageKey: String = "language",
        regionKey: String = "region") {
        self.locale = locale
        self.languageKey = languageKey
        self.regionKey = regionKey
    }
    
    func prepare(request: URLRequest) throws -> URLRequest {
        guard
            let languageCode = locale.languageCode,
            let region = locale.regionCode,
            let url = request.url,
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else { return request }
        
        let languageIdentifier = languageCode + "-" + region
        let languageQuery = URLQueryItem(name: languageKey, value: languageIdentifier)
        let regionQuery = URLQueryItem(name: regionKey, value: region)
        let queryItems = (urlComponents.queryItems ?? []) + [languageQuery, regionQuery]
        urlComponents.queryItems = queryItems
        
        var mutableRequest = request
        mutableRequest.url = urlComponents.url
        
        return mutableRequest
    }
    
    func willSend(request: URLRequest) {}
    
    func didReceive(response: URLResponse, data: Data) throws {}
}

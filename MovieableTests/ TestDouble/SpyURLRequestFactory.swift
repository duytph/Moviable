//
//  SpyURLRequestFactory.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/4/20.
//

import Foundation
import Networkable

final class SpyURLRequestFactory: URLRequestFactory {
    
    var invokedHostSetter = false
    var invokedHostSetterCount = 0
    var invokedHost: String?
    var invokedHostList = [String]()
    var invokedHostGetter = false
    var invokedHostGetterCount = 0
    var stubbedHost: String! = ""

    var host: String {
        set {
            invokedHostSetter = true
            invokedHostSetterCount += 1
            invokedHost = newValue
            invokedHostList.append(newValue)
        }
        get {
            invokedHostGetter = true
            invokedHostGetterCount += 1
            return stubbedHost
        }
    }

    var invokedCachePolicySetter = false
    var invokedCachePolicySetterCount = 0
    var invokedCachePolicy: URLRequest.CachePolicy?
    var invokedCachePolicyList = [URLRequest.CachePolicy]()
    var invokedCachePolicyGetter = false
    var invokedCachePolicyGetterCount = 0
    var stubbedCachePolicy: URLRequest.CachePolicy!

    var cachePolicy: URLRequest.CachePolicy {
        set {
            invokedCachePolicySetter = true
            invokedCachePolicySetterCount += 1
            invokedCachePolicy = newValue
            invokedCachePolicyList.append(newValue)
        }
        get {
            invokedCachePolicyGetter = true
            invokedCachePolicyGetterCount += 1
            return stubbedCachePolicy
        }
    }

    var invokedTimeoutIntervalSetter = false
    var invokedTimeoutIntervalSetterCount = 0
    var invokedTimeoutInterval: TimeInterval?
    var invokedTimeoutIntervalList = [TimeInterval]()
    var invokedTimeoutIntervalGetter = false
    var invokedTimeoutIntervalGetterCount = 0
    var stubbedTimeoutInterval: TimeInterval!

    var timeoutInterval: TimeInterval {
        set {
            invokedTimeoutIntervalSetter = true
            invokedTimeoutIntervalSetterCount += 1
            invokedTimeoutInterval = newValue
            invokedTimeoutIntervalList.append(newValue)
        }
        get {
            invokedTimeoutIntervalGetter = true
            invokedTimeoutIntervalGetterCount += 1
            return stubbedTimeoutInterval
        }
    }

    var invokedMake = false
    var invokedMakeCount = 0
    var invokedMakeParameters: (endpoint: Endpoint, Void)?
    var invokedMakeParametersList = [(endpoint: Endpoint, Void)]()
    var stubbedMakeError: Error?
    var stubbedMakeResult: URLRequest!

    func make(endpoint: Endpoint) throws -> URLRequest {
        invokedMake = true
        invokedMakeCount += 1
        invokedMakeParameters = (endpoint, ())
        invokedMakeParametersList.append((endpoint, ()))
        if let error = stubbedMakeError {
            throw error
        }
        return stubbedMakeResult
    }
}

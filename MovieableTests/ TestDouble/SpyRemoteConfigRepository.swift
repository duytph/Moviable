//
//  SpyRemoteConfigRepository.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/4/20.
//

import Combine
import Foundation
@testable import Movieable

final class SpyRemoteConfigRepository: RemoteConfigRepository {

    var invokedConfigurationGetter = false
    var invokedConfigurationGetterCount = 0
    var stubbedConfiguration: Configuration!

    var configuration: Configuration {
        invokedConfigurationGetter = true
        invokedConfigurationGetterCount += 1
        return stubbedConfiguration
    }

    var invokedConfigurationPublisherGetter = false
    var invokedConfigurationPublisherGetterCount = 0
    var stubbedConfigurationPublisher: AnyPublisher<Configuration, Never>!

    var configurationPublisher: AnyPublisher<Configuration, Never> {
        invokedConfigurationPublisherGetter = true
        invokedConfigurationPublisherGetterCount += 1
        return stubbedConfigurationPublisher
    }

    var invokedRefresh = false
    var invokedRefreshCount = 0

    func refresh() {
        invokedRefresh = true
        invokedRefreshCount += 1
    }
}

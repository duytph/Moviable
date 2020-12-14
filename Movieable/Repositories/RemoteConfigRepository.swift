//
//  RemoteConfigRepository.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import Combine
import Foundation
import Networkable
import os.log

protocol RemoteConfigRepository {
    
    var configuration: Configuration { get }
    var configurationPublisher: AnyPublisher<Configuration, Never> { get }
    
    func refresh()
}

final class DefaultRemoteConfigWebRepository: RemoteConfigRepository, WebRepository {

    static let shared = DefaultRemoteConfigWebRepository()
    
    // MARK: - Dependencies
    
    let requestFactory: URLRequestFactory
    let middlewares: [Middleware]
    let session: URLSession
    
    @Published private(set) var configuration: Configuration = .defaultValue
    
    var configurationPublisher: AnyPublisher<Configuration, Never> {
        $configuration.eraseToAnyPublisher()
    }
    
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(
        requestFactory: URLRequestFactory = DefaultURLRequestFactory.defaultValue,
        middlewares: [Middleware] = .defaultValue,
        session: URLSession = .shared) {
        self.requestFactory = requestFactory
        self.middlewares = middlewares
        self.session = session
    }
    
    // MARK: - MovieRepository
    
    func refresh() {
        /*Default caching implementation is HTTP cache, so it free to call refresh anytime to retrieve cached response*/
        let endpoint = APIEndpoint.configuration
        call(to: endpoint)
            .sink { (completion: Subscribers.Completion<Error>) in
                switch completion {
                case let .failure(error):
                    os_log(
                        .error,
                        "Refreshing configuration failed because of %@",
                        error.localizedDescription)
                case .finished:
                    os_log("Refreshing configuration finished")
                }
            } receiveValue: { [weak self] (configuration: Configuration) in
                self?.configuration = configuration
            }
            .store(in: &cancelBag)
    }
}

extension DefaultRemoteConfigWebRepository {
    
    enum APIEndpoint: Endpoint {
        
        case configuration
        
        var url: String {
            "/\(Natrium.Config.apiVersion)/configuration"
        }
        
        var method: Networkable.Method {
            .get
        }
        
        func body() throws -> Data? {
            nil
        }
    }
}

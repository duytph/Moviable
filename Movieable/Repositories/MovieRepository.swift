//
//  MovieRepository.swift
//  Movieable
//
//  Created by Duy Tran on 10/3/20.
//

import Combine
import Foundation
import Networking

protocol MovieRepository {
    
    func popular(page: Int) -> AnyPublisher<PaginationResponse<Movie>, Error>
    func movie(id: Int) -> AnyPublisher<Movie, Error>
}

struct DefaultMovieRepository: MovieRepository, Repository {
    
    static let shared = DefaultMovieRepository()
    
    // MARK: - Dependencies
    
    let requestFactory: URLRequestFactory
    let middlewares: [Middleware]
    let session: URLSession
    
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
    
    func popular(page: Int) -> AnyPublisher<PaginationResponse<Movie>, Error> {
        return call(to: APIEndpoint.popular(page: page))
    }
    
    func movie(id: Int) -> AnyPublisher<Movie, Error> {
        let endpoint = APIEndpoint.movie(id: id)
        return call(to: endpoint)
    }
}

extension DefaultMovieRepository {
    
    enum APIEndpoint: Networking.Endpoint {
        
        case popular(page: Int)
        case movie(id: Int)
        
        var path: String {
            switch self {
            case let .popular(page):
                return "/movie/popular?page=\(page)"
            case let .movie(id):
                return "/movie/\(id)"
            }
        }
        
        var method: Networking.Method {
            .get
        }
        
        func body() throws -> Data? {
            nil
        }
    }
}

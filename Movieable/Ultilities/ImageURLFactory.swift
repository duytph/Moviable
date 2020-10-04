//
//  ImageURLFactory.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import Combine
import Foundation

enum ImageSize: Equatable, Hashable, CaseIterable {
    case small, medium, original
}

protocol ImageURLFactory {
    
    var images: Images { get set }
    
    func make(
        baseURL: String,
        size: String,
        path: String) -> URL?
    
    func make(
        isSecure: Bool,
        imageSize: ImageSize,
        in keyPath: KeyPath<Images, [String]>,
        path: String) -> URL?
}

final class DefaultImageURLFactory: ImageURLFactory {
    
    static let shared = DefaultImageURLFactory()
    
    // MARK: - Dependencies
    
    var images: Images
    
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(
        images: Images = .defaultValue,
        remoteConfigRepository: RemoteConfigRepository = DefaultRemoteConfigRepository.shared) {
        self.images = images
        remoteConfigRepository
            .configurationPublisher
            .map(\.images)
            .assign(to: \.images, on: self)
            .store(in: &cancelBag)
    }
    
    // MARK: - ImageURLFactory
    
    func make(
        baseURL: String,
        size: String,
        path: String) -> URL? {
        guard
            !baseURL.isEmpty,
            !size.isEmpty,
            !path.isEmpty
        else { return nil }
        
        let rawURL = baseURL + "/" + size + "/" + path
        let url = URL(string: rawURL)
        return url
    }
    
    func make(
        isSecure: Bool = true,
        imageSize: ImageSize,
        in keyPath: KeyPath<Images, [String]>,
        path: String) -> URL? {
        let sizes = images[keyPath: keyPath]
        guard let size = self.size(associatedWith: imageSize, sizes: sizes) else { return nil }
        let baseURL = isSecure ? images.secureBaseURL : images.baseURL
        return self.make(baseURL: baseURL, size: size, path: path)
    }
    
    // MARK: - Ultilities
    
    func size(associatedWith imageSize: ImageSize, sizes: [String]) -> String? {
        guard !sizes.isEmpty else { return nil }
        
        switch imageSize {
        case .small:
            return sizes.first
        case .medium:
            let index = (sizes.count - 1) / 2
            let mid = sizes[index]
            return mid
        case .original:
            return sizes.last
        }
    }
}

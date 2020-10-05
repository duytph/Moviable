//
//  SpyImageURLFactory.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/5/20.
//

import Foundation
@testable import Movieable

final class SpyImageURLFactory: ImageURLFactory {

    var invokedImagesSetter = false
    var invokedImagesSetterCount = 0
    var invokedImages: Images?
    var invokedImagesList = [Images]()
    var invokedImagesGetter = false
    var invokedImagesGetterCount = 0
    var stubbedImages: Images!

    var images: Images {
        set {
            invokedImagesSetter = true
            invokedImagesSetterCount += 1
            invokedImages = newValue
            invokedImagesList.append(newValue)
        }
        get {
            invokedImagesGetter = true
            invokedImagesGetterCount += 1
            return stubbedImages
        }
    }

    var invokedMake = false
    var invokedMakeCount = 0
    var invokedMakeParameters: (baseURL: String, size: String, path: String)?
    var invokedMakeParametersList = [(baseURL: String, size: String, path: String)]()
    var stubbedMakeResult: URL!

    func make(
        baseURL: String,
        size: String,
        path: String) -> URL? {
        invokedMake = true
        invokedMakeCount += 1
        invokedMakeParameters = (baseURL, size, path)
        invokedMakeParametersList.append((baseURL, size, path))
        return stubbedMakeResult
    }

    var invokedMakeIsSecure = false
    var invokedMakeIsSecureCount = 0
    var invokedMakeIsSecureParameters: (isSecure: Bool, imageSize: ImageSize, keyPath: KeyPath<Images, [String]>, path: String)?
    var invokedMakeIsSecureParametersList = [(isSecure: Bool, imageSize: ImageSize, keyPath: KeyPath<Images, [String]>, path: String)]()
    var stubbedMakeIsSecureResult: URL!

    func make(
        isSecure: Bool,
        imageSize: ImageSize,
        in keyPath: KeyPath<Images, [String]>,
        path: String) -> URL? {
        invokedMakeIsSecure = true
        invokedMakeIsSecureCount += 1
        invokedMakeIsSecureParameters = (isSecure, imageSize, keyPath, path)
        invokedMakeIsSecureParametersList.append((isSecure, imageSize, keyPath, path))
        return stubbedMakeIsSecureResult
    }
}

//
//  DefaultImageURLFactoryTests.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/4/20.
//

import Combine
import XCTest
@testable import Movieable

final class DefaultImageURLFactoryTests: XCTestCase {
    
    var smallSize: String!
    var mediumSize: String!
    var originalSize: String!
    var images: Images!
    var remoteConfigRepository: SpyRemoteConfigRepository!
    var sut: DefaultImageURLFactory!
    
    override func setUpWithError() throws {
        smallSize = "small"
        mediumSize = "medium"
        originalSize = "original"
        images = Images(
            baseURL: "http://www.apple.com",
            secureBaseURL: "https://www.apple.com",
            backdropSizes: [smallSize, mediumSize, originalSize],
            logoSizes: [],
            posterSizes: [],
            profileSizes: [],
            stillSizes: [])
        remoteConfigRepository = SpyRemoteConfigRepository()
        remoteConfigRepository.stubbedConfigurationPublisher = Empty<Configuration, Never>().eraseToAnyPublisher()
        sut = DefaultImageURLFactory(
            images: images,
            remoteConfigRepository: remoteConfigRepository)
    }
    
    override func tearDownWithError() throws {
        remoteConfigRepository = nil
        sut = nil
    }
    
    func testInit() {
        XCTAssertEqual(sut.images, images)
        XCTAssertTrue(remoteConfigRepository.invokedConfigurationPublisherGetter)
    }
    
    func testSizeWhenSizesIsEmpty() {
        let sizes = [String]()
        ImageSize.allCases.forEach { (imageSize: ImageSize) in
            XCTAssertNil(sut.size(associatedWith: imageSize, sizes: sizes))
        }
    }
    
    func testSize() {
        let sizes = [smallSize!, "Foo", mediumSize!, "Bar", originalSize!]
        XCTAssertEqual(sut.size(associatedWith: .small, sizes: sizes), smallSize)
        XCTAssertEqual(sut.size(associatedWith: .medium, sizes: sizes), mediumSize)
        XCTAssertEqual(sut.size(associatedWith: .original, sizes: sizes), originalSize)
    }
    
    func testMakeWithBaseURLSizeAndPath() {
        XCTAssertNil(sut.make(baseURL: "", size: "foo", path: "bar"))
        XCTAssertNil(sut.make(baseURL: "", size: "", path: "bar"))
        XCTAssertNil(sut.make(baseURL: "https://fizz.buzz", size: "", path: ""))
        XCTAssertNil(sut.make(baseURL: "", size: "foo", path: ""))
        XCTAssertNil(sut.make(baseURL: "", size: "", path: ""))
        XCTAssertEqual(
            sut.make(
                baseURL: "https://www.apple.com",
                size: "original",
                path: "placeholder")?.absoluteString,
            "https://www.apple.com/original/placeholder")
    }
    
    func testMakeWithIsSecure() {
        let imageSize = ImageSize.small
        let keyPath = \Images.backdropSizes
        let path = "path"
        
        XCTAssertTrue(
            sut.make(
                isSecure: true,
                imageSize: imageSize,
                in: keyPath,
                path: path)!
                .absoluteString
                .contains(images.secureBaseURL))
        
        XCTAssertTrue(
            sut.make(
                isSecure: false,
                imageSize: imageSize,
                in: keyPath,
                path: path)!
                .absoluteString
                .contains(images.baseURL))
    }
    
    func testMakeWithImageSizeInKeyPath() {
        let isSecure = false
        let keyPath = \Images.backdropSizes
        let path = "path"
        
        XCTAssertNil(
            sut.make(
                isSecure: isSecure,
                imageSize: .small,
                in: \Images.logoSizes,
                path: path))
        
        XCTAssertTrue(
            sut.make(
                isSecure: isSecure,
                imageSize: .small,
                in: keyPath,
                path: path)!
                .absoluteString
                .contains(smallSize))
        
        XCTAssertTrue(
            sut.make(
                isSecure: isSecure,
                imageSize: .medium,
                in: keyPath,
                path: path)!
                .absoluteString
                .contains(mediumSize))
        
        XCTAssertTrue(
            sut.make(
                isSecure: isSecure,
                imageSize: .original,
                in: keyPath,
                path: path)!
                .absoluteString
                .contains(originalSize))
    }
}

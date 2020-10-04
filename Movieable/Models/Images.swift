//
//  Images.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import Foundation

struct Images: Codable, Equatable, Hashable {
    
    let baseURL: String
    let secureBaseURL: String
    let backdropSizes, logoSizes, posterSizes, profileSizes: [String]
    let stillSizes: [String]
    
    enum CodingKeys: String, CodingKey {
        case baseURL = "base_url"
        case secureBaseURL = "secure_base_url"
        case backdropSizes = "backdrop_sizes"
        case logoSizes = "logo_sizes"
        case posterSizes = "poster_sizes"
        case profileSizes = "profile_sizes"
        case stillSizes = "still_sizes"
    }
}

extension Images {
    
    static var defaultValue: Images {
        Images(
            baseURL: "http://image.tmdb.org/t/p/",
            secureBaseURL: "https://image.tmdb.org/t/p/",
            backdropSizes: ["w300", "w780", "w1280", "original"],
            logoSizes: ["w45", "w92", "w154", "w185", "w300", "w500", "original"],
            posterSizes: ["w92", "w154", "w185", "w342", "w500", "w780", "original"],
            profileSizes: ["w45", "w185", "h632", "original"],
            stillSizes: ["w92", "w185", "w300", "original"])
    }
}

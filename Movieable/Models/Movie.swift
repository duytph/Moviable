//
//  Movie.swift
//  Movieable
//
//  Created by Duy Tran on 10/3/20.
//

import Foundation

struct Movie: Codable, Equatable, Hashable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        case popularity
        case voteCount = "vote_count"
        case video
        case posterPath = "poster_path"
        case id
        case adult
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIDS = "genre_ids"
        case title
        case voteAverage = "vote_average"
        case overview
        case releaseDate = "release_date"
    }
    
    let popularity: Double?
    let voteCount: Int?
    let video: Bool?
    let posterPath: String?
    let id: Int
    let adult: Bool?
    let backdropPath: String?
    let originalLanguage: String?
    let originalTitle: String?
    let genreIDS: [Int]?
    let title: String?
    let voteAverage: Double?
    let overview: String?
    let releaseDate: String?
}
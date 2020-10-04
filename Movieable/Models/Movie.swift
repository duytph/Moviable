//
//  Movie.swift
//  Movieable
//
//  Created by Duy Tran on 10/3/20.
//

import Foundation

struct Movie: Codable, Equatable, Hashable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    let adult: Bool?
    let backdropPath: String?
    let budget: Int?
    let genres: [Genre]?
    let homepage: String?
    let id: Int
    let imdbID, originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let revenue, runtime: Int?
    let spokenLanguages: [SpokenLanguage]?
    let status, tagline, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
}

extension Movie: Emptiable {
    
    var isEmpty: Bool {
        id <= 0
    }
}

struct Genre: Codable, Equatable, Hashable, Identifiable {
    
    let id: Int?
    let name: String?
}

struct SpokenLanguage: Codable, Equatable, Hashable {
    
    let identifier, name: String?

    enum CodingKeys: String, CodingKey {
        case identifier = "iso_639_1"
        case name
    }
}

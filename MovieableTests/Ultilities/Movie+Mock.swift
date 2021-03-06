//
//  Movie+Mock.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/5/20.
//

import Foundation
@testable import Movieable

extension Movie {
    
    static var mock: Movie {
        let data = """
        {
          "adult": false,
          "backdrop_path": "/cCvp5Sni75agCtyJkNOMapORUQV.jpg",
          "belongs_to_collection": null,
          "budget": 25000000,
          "genres": [
            {
              "id": 28,
              "name": "Action"
            },
            {
              "id": 80,
              "name": "Crime"
            },
            {
              "id": 18,
              "name": "Drama"
            },
            {
              "id": 53,
              "name": "Thriller"
            }
          ],
          "homepage": "",
          "id": 111,
          "imdb_id": "tt0086250",
          "original_language": "en",
          "original_title": "Scarface",
          "overview": "After getting a green card in exchange for assassinating a Cuban government official, Tony Montana stakes a claim on the drug trade in Miami. Viciously murdering anyone who stands in his way, Tony eventually becomes the biggest drug lord in the state, controlling nearly all the cocaine that comes through Miami. But increased pressure from the police, wars with Colombian drug cartels and his own drug-fueled paranoia serve to fuel the flames of his eventual downfall.",
          "popularity": 32.683,
          "poster_path": "/nGY6NnlDsWaRKAycWUgXanqLxia.jpg",
          "production_companies": [
            {
              "id": 33,
              "logo_path": "/8lvHyhjr8oUKOOy2dKXoALWKdp0.png",
              "name": "Universal Pictures",
              "origin_country": "US"
            }
          ],
          "production_countries": [
            {
              "iso_3166_1": "US",
              "name": "United States of America"
            }
          ],
          "release_date": "1983-12-08",
          "revenue": 66023329,
          "runtime": 170,
          "spoken_languages": [
            {
              "iso_639_1": "en",
              "name": "English"
            },
            {
              "iso_639_1": "es",
              "name": "Español"
            }
          ],
          "status": "Released",
          "tagline": "The world is yours...",
          "title": "Scarface",
          "video": false,
          "vote_average": 8.1,
          "vote_count": 7435
        }
        """
            .data(using: .utf8)!
        let decoder = JSONDecoder()
        let movie = try! decoder.decode(Movie.self, from: data)
        return movie
    }
}

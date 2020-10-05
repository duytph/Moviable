//
//  MovieTableViewCellTests.swift
//  MovieableTests
//
//  Created by Duy Tran on 10/5/20.
//

import UIKit
import XCTest
@testable import Movieable

final class MovieTableViewCellTests: XCTestCase {
    
    var movie: Movie!
    var sut: MovieTableViewCell!

    override func setUpWithError() throws {
        let data = """
        {
          "poster_path": "/e1mjopzAS2KNsvpbpahQ1a6SkSn.jpg",
          "adult": false,
          "overview": "From DC Comics comes the Suicide Squad, an antihero team of incarcerated supervillains who act as deniable assets for the United States government, undertaking high-risk black ops missions in exchange for commuted prison sentences.",
          "release_date": "2016-08-03",
          "genre_ids": [
            14,
            28,
            80
          ],
          "id": 297761,
          "original_title": "Suicide Squad",
          "original_language": "en",
          "title": "Suicide Squad",
          "backdrop_path": "/ndlQ2Cuc3cjTL7lTynw6I4boP4S.jpg",
          "popularity": 48.261451,
          "vote_count": 1466,
          "video": false,
          "vote_average": 5.91
        }
        """
            .data(using: .utf8)!
        movie = try JSONDecoder().decode(Movie.self, from: data)
        sut = MovieTableViewCell.loadFromNib()
    }

    override func tearDownWithError() throws {
        movie = nil
        sut = nil
    }
    
    func testPrepareForReuse() throws {
        sut.prepareForReuse()
        
        XCTAssertNil(sut.posterImageView.kf.taskIdentifier)
        XCTAssertNil(sut.popularityLabel.text)
        XCTAssertNil(sut.titleLabel.text)
        XCTAssertNil(sut.releaseDateLabel.text)
        XCTAssertNil(sut.overviewLabel.text)
    }

    func testConfigureWithMovie() throws {
        sut.configure(withMovie: movie)
        
        let popularity = sut.numberFormatter.string(
            from: NSNumber(
                value: movie.popularity!))!
        XCTAssertEqual(sut.titleLabel.text, movie.title)
        XCTAssertEqual(sut.popularityLabel.text, popularity)
        XCTAssertEqual(sut.titleLabel.text, movie.title)
        XCTAssertEqual(sut.releaseDateLabel.text, movie.releaseDate)
        XCTAssertEqual(sut.overviewLabel.text, movie.overview)
        XCTAssertNotNil(sut.posterImageView.kf.placeholder)
    }
}

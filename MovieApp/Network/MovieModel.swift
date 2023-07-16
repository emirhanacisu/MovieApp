//
//  MovieModel.swift
//  MovieApp
//
//  Created by emirhan Acısu on 15.07.2023.
//

import Foundation

struct MovieResponse: Codable {
    let search: [Movie]
    let totalResults: String

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
    }
}

// MARK: - Movie
struct Movie: Codable {
    let title: String?
    let year: String?
    let poster: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case poster = "Poster"
    }
}

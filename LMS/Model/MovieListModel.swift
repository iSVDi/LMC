//
//  MovieListModel.swift
//  LMS
//
//  Created by Daniil on 12.09.2024.
//

import Foundation

// MARK: - MovieList
struct MovieListModel: Codable {
    let items: [MovieListItemModel]
}

// MARK: - Item
struct MovieListItemModel: Codable {
    let kinopoiskID: Int
    let nameOriginal: String?
    let countries: [CountryModel]
    let genres: [GenreModel]
    let ratingKinopoisk: Double
    let year: Int
    let posterURLPreview: String
    enum CodingKeys: String, CodingKey {
        case kinopoiskID = "kinopoiskId"
        case  nameOriginal, countries, genres, ratingKinopoisk,  year
        case posterURLPreview = "posterUrlPreview"
    }
}



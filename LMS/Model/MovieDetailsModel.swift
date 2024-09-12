//
//  MoviewDetailsModel.swift
//  LMS
//
//  Created by Daniil on 12.09.2024.
//

import Foundation

// MARK: - MoviewDetailsModel
struct MovieDetailsModel: Codable {
    let kinopoiskID: Int
    let nameOriginal: String
    let description: String
    let countries: [CountryModel]
    let genres: [GenreModel]
    let startYear, endYear: Int
    let ratingKinopoisk: Double
    let coverURL: String
    
    
    enum CodingKeys: String, CodingKey {
        case kinopoiskID = "kinopoiskId"
        case nameOriginal
        case description, countries, genres, startYear, endYear, ratingKinopoisk
        case coverURL = "coverUrl"
    }
}

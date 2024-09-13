//
//  MovieListModel.swift
//  LMS
//
//  Created by Daniil on 12.09.2024.
//

import Foundation

// MARK: - MovieList
struct MovieListModel: Codable {
    let total: Int
    let totalPages: Int
    let items: [MovieListItemModel]
    
    init() {
        items = []
        total = 0
        totalPages = 1
    }
}

// MARK: - Item
// TODO: add another names and return one of them
struct MovieListItemModel: Codable {
    let kinopoiskID: Int
    private let nameOriginal: String?
    private let nameRu: String?
    private let nameEn: String?
    let countries: [CountryModel]
    let genres: [GenreModel]
    let ratingKinopoisk: Double?
    let year: Int
    let posterURLPreview: String
    enum CodingKeys: String, CodingKey {
        case kinopoiskID = "kinopoiskId"
        case nameOriginal, nameRu, nameEn, countries, genres, ratingKinopoisk,  year
        case posterURLPreview = "posterUrlPreview"
    }
    
    var getName: String {
        return nameOriginal ?? nameEn ?? nameRu ?? ""
    }
    
}



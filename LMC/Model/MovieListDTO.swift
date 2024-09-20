//
//  MovieListDTO.swift
//  LMC
//
//  Created by daniil on 20.09.2024.
//

import Foundation

// MARK: - MovieListDTO
class MovieListDTO: Codable {
    let totalPages: Int
    var items: [MovieListItemDTO]
    
    init(totalPages: Int, items: [MovieListItemDTO]) {
        self.totalPages = totalPages
        self.items = items
    }
}


// MARK: - Item
struct MovieListItemDTO: Codable {
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
    
    var getRatingString: String {
        guard let ratingKinopoisk else {
            return ""
        }
        return "\(ratingKinopoisk)"
    }
    
}




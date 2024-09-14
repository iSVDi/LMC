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
    private let nameRu: String?
    private let nameEn: String?
    private let nameOriginal: String?
    let description: String?
    let countries: [CountryModel]
    let genres: [GenreModel]
    private let startYear, endYear: Int?
    private let year: Int?
    let ratingKinopoisk: Double?
    let coverURL: String?
    let webUrl: String?
    
    
    enum CodingKeys: String, CodingKey {
        case kinopoiskID = "kinopoiskId"
        case nameOriginal, nameRu, nameEn
        case description, countries, genres, startYear, endYear, year, ratingKinopoisk, webUrl
        case coverURL = "coverUrl"
    }
    
    func getName() -> String {
        return nameOriginal ?? nameEn ?? nameRu ?? ""
    }
    
    func getYearTitle() -> String {
        if let startYear = startYear, let endYear = endYear {
            if (startYear == endYear) {
                return "\(startYear), "
            }
            return "\(startYear) - \(endYear), "
        } else if let startYear = startYear {
            return "\(startYear) -, "
        }
        else if let year = year {
            return "\(year), "
        }
        return ""
    }
}

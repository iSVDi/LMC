//
//  MoviewDetailsModel.swift
//  LMS
//
//  Created by Daniil on 12.09.2024.
//

import Foundation

// MARK: - MoviewDetailsModel
struct MovieDetailsDTO: Codable {
    let kinopoiskID: Int
    private let nameRu: String?
    private let nameEn: String?
    private let nameOriginal: String?
    let description: String?
    let countries: [CountryDTO]
    let genres: [GenreDTO]
    private let startYear, endYear: Int?
    private let year: Int?
    let ratingKinopoisk: Double?
    let coverURL: String?
    let posterURL: String?
    let webUrl: String?
    
    
    enum CodingKeys: String, CodingKey {
        case kinopoiskID = "kinopoiskId"
        case nameOriginal, nameRu, nameEn
        case description, countries, genres, startYear, endYear, year, ratingKinopoisk, webUrl
        case coverURL = "coverUrl"
        case posterURL = "posterUrl"
    }
    
    func getName() -> String {
        let names = [nameOriginal, nameEn, nameRu]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
        return names.first ?? ""
        
    }
    
    func getYearTitle() -> String {
        if let startYear = startYear, let endYear = endYear {
            if (startYear == endYear) {
                return "\(startYear), "
            }
            return "\(startYear)-\(endYear), "
        } else if let startYear = startYear {
            return "\(startYear) -, "
        }
        else if let year = year {
            return "\(year), "
        }
        return ""
    }
    
    func getImageURL() -> URL? {
        guard let stringURL = coverURL ?? posterURL,
              !stringURL.isEmpty else {
            return nil
        }
        return URL(string: stringURL)
    }
    
    func getModel() -> MovieDetailsModel {
        return MovieDetailsModel(
            name: getName(),
            description: description ?? "",
            countries: countries.map{ $0.country }.joined(separator: ", "),
            genres: genres.map{ $0.genre }.joined(separator: ", "),
            years: getYearTitle(),
            ratingKinopoisk: ratingKinopoisk,
            coverURL: getImageURL(),
            webUrl: webUrl ?? ""
        )
    }
    
}

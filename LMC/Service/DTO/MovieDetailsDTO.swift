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
    let webUrl: String?
    
    
    enum CodingKeys: String, CodingKey {
        case kinopoiskID = "kinopoiskId"
        case nameOriginal, nameRu, nameEn
        case description, countries, genres, startYear, endYear, year, ratingKinopoisk, webUrl
        case coverURL = "coverUrl"
    }
    
    func getName() -> String {
        /* CODEREVIEW:
         Пробелы возле фигурных: { $0 } и т.д.
         */
        let names = [nameOriginal, nameEn, nameRu]
            .compactMap {$0}
            .filter {!$0.isEmpty}
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
    
    func getModel() -> MovieDetailsModel {
        /* CODEREVIEW:
         Отформатируй аргументы

         Нужно отступать пробел перед и после фигурных скобок: .map { $0.country }

         У деталей фильма помимо coverUrl есть еще posterUrl.
         Он чаще присутствует. Можно сделать дефолт также на него, чтобы контент показывался:
         coverURL ?? posterURL ?? ""

         Ну и плюс если у тебя эта модель для UI, может сразу сделаешь её типа URL, а не String?
         Не придется конвертить во вьюхе
         */
        let res = MovieDetailsModel(name: getName(),
                                    description: description ?? "",
                                    countries: countries.map{$0.country}.joined(separator: ", "),
                                    genres: genres.map{$0.genre}.joined(separator: ", "),
                                    years: getYearTitle(),
                                    ratingKinopoisk: ratingKinopoisk,
                                    coverURL: coverURL ?? "",
                                    webUrl: webUrl ?? "")
        
        return res
    }
    
}


//
//  MovieDetailsModel.swift
//  LMC
//
//  Created by daniil on 20.09.2024.
//

import Foundation

struct MovieDetailsModel {
    let name: String
    let description: String
    let countries: String
    let genres: String
    let years: String
    let ratingKinopoisk: Double?
    let coverURL: String
    let webUrl: String
    
    init() {
        name = ""
        description = ""
        countries = ""
        genres = ""
        years = ""
        ratingKinopoisk = nil
        coverURL = ""
        webUrl = ""
    }
    
    init(name: String, description: String, countries: String, genres: String, years: String, ratingKinopoisk: Double?, coverURL: String, webUrl: String) {
        self.name = name
        self.description = description
        self.countries = countries
        self.genres = genres
        self.years = years
        self.ratingKinopoisk = ratingKinopoisk
        self.coverURL = coverURL
        self.webUrl = webUrl
    }
}

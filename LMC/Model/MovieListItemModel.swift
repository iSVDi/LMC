//
//  MovieListItemModel.swift
//  LMC
//
//  Created by daniil on 19.09.2024.
//

import SwiftUI

struct MovieListItemModel: Identifiable {
    let id = UUID()
    let title: String
    let genre: String
    let year: Int
    let country: String
    let rating: Double?
    let posterUrlPreview: String
    
    init(title: String, genre: String, year: Int, country: String, rating: Double?, posterUrlPreview: String) {
        self.title = title
        self.genre = genre
        self.year = year
        self.country = country
        self.rating = rating
        self.posterUrlPreview = posterUrlPreview
    }
}

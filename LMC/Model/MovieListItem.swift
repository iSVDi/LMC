//
//  MovieListItem.swift
//  LMC
//
//  Created by daniil on 19.09.2024.
//

import SwiftUI

struct MovieListItem: Identifiable {
    let id = UUID()
    let title: String
    let genre: String
    let year: Int
    let country: String
    let rating: Double
    
    init(title: String, genre: String, year: Int, country: String, rating: Double) {
        self.title = title
        self.genre = genre
        self.year = year
        self.country = country
        self.rating = rating
    }
}

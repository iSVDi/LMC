//
//  MoviesViewModel.swift
//  LMC
//
//  Created by daniil on 20.09.2024.
//

import SwiftUI

class MoviesViewModel: ObservableObject {
    private let repository = MoviesRepository()
    private var currentFilter = MovieFilterDTO.rating
    private var totalPages = 1
    private var currentPage = 1
    @Published var movies: [MovieListItemModel] = []
    @Published var isFooterViewPresented = false
    
    init() {
        loadMovies()
    }
    
    func handleLastCell(id: UUID) {
        guard movies.last?.id == id,
              currentPage + 1 <= totalPages
        else {
            return
        }
        isFooterViewPresented = true
        currentPage += 1
        loadMovies()
    }
    
    func handleNewFilter(filter: MovieFilterDTO) {
        currentFilter = filter
        loadFirstPage()
    }
    
    private func loadMovies() {
        repository.getMovies(filter: currentFilter, page: currentPage) { [weak self] dto in
            self?.totalPages = dto.totalPages
            let newMovies = dto.items.map { dtoItem in
                return MovieListItemModel(title: dtoItem.getName,
                                          genre: dtoItem.genres.map({$0.genre}).joined(separator: ", "),
                                          year: dtoItem.year,
                                          country: dtoItem.countries.map{$0.country}.joined(separator: ", "),
                                          rating: dtoItem.ratingKinopoisk,
                                          posterUrlPreview: dtoItem.posterURLPreview)
            }
            self?.isFooterViewPresented = false
            self?.movies.append(contentsOf: newMovies)
        }
    }
    
    private func loadFirstPage() {
        currentPage = 1
        movies = []
        loadMovies()
    }
}



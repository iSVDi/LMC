//
//  MoviesViewModel.swift
//  LMC
//
//  Created by daniil on 20.09.2024.
//

import SwiftUI

final class MoviesViewModel: ObservableObject {
    private let repository = MoviesRepository()
    private let authDataManager = AuthDataManager.shared
    private var currentFilter = MovieFilterDTO.rating
    private var totalPages = 1
    private var currentPage = 1
    private(set) var movies: [MovieListItemModel] = []
    @Published var filteredMovies: [MovieListItemModel] = []
    @Published var shouldLoadNextPage = false
    @Published var searchRequest = ""
    
    init() {
        loadMovies()
    }
    
    func handleLastCell(id: UUID) {
        shouldLoadNextPage = false
        guard currentPage + 1 <= totalPages else {
            return
        }
        currentPage += 1
        loadMovies()
    }
    
    func handleProgressIsPresented() {
        guard currentPage <= totalPages else {
            return
        }
        loadMovies()
    }
    
    func handleNewFilter(filter: MovieFilterDTO) {
        currentFilter = filter
        loadFirstPage()
    }
    
    func handleSearch(_ request: String) {
        searchRequest = request
        guard !request.isEmpty else {
            filteredMovies = movies
            return
        }
        
        /* CODEREVIEW:
         А поиск только локальный? В запросе невозможно передать query?
         */
        filteredMovies = movies.filter { model in
            let lowerCasedSearch = request.lowercased()
            return model.title.lowercased().contains(lowerCasedSearch) ||
            model.genre.lowercased().contains(lowerCasedSearch) ||
            model.country.lowercased().contains(lowerCasedSearch)
        }
        
    }
    
    func handleExitButton() {
        authDataManager.isNeedSignIn = true
        
        /* CODEREVIEW:
         А точно нужно здесь сбрасывать состояние?
         У тебя же в LMCApp будет использоваться другая вьюха, и эта вью модель в целом должна
         выгрузиться из памяти.
         */
        currentPage = 1
        movies = []
        searchRequest = ""
    }
    
    private func loadMovies() {
        repository.getMovies(filter: currentFilter, page: currentPage) { [weak self] dto in
            guard let self else {
                return
            }
            self.totalPages = dto.totalPages
            let newMovies = dto.items.map {
                /* CODEREVIEW:
                 Отформатировать переносы
                 */
                MovieListItemModel(
                    kinopoiskID: $0.kinopoiskID,
                    title: $0.getName,
                    genre: $0.genres.map({$0.genre}).joined(separator: ", "),
                    year: $0.year,
                    country: $0.countries.map{$0.country}.joined(separator: ", "),
                    rating: $0.ratingKinopoisk,
                    posterUrlPreview: $0.posterURLPreview)
            }
            self.movies.append(contentsOf: newMovies)
            self.handleSearch(searchRequest)
            
            guard currentPage + 1 <= totalPages else {
                shouldLoadNextPage = false
                return
            }
            shouldLoadNextPage = true
            currentPage += 1
        }
    }
    
    private func loadFirstPage() {
        currentPage = 1
        movies = []
        loadMovies()
    }
}

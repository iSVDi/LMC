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
    /* CODEREVIEW:
     Лучше переименовать на shouldLoadNextPage, по дефолту как сейчас false,
     но сеттить в true в комплишене getMovies, если размер массива равен размеру страницы
     */
    @Published var isFooterViewPresented = false
    private var searchRequest = ""
    
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
    
    func handleSearch(_ request: String) {
        /* CODEREVIEW:
         Сейчас получается два источника правды - тут в свойстве searchRequest, и во вьюхе
         в стейте searchText

         Лучше оставить одно здесь, сделать его Published, а во вьюхе через биндинг к нему подвязаться

         Несколько источников истины могут приводить к багам, лучше их минимизировать
         */
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

    /* CODEREVIEW:
     Не используется
     */
    func handleDismissAuthView() {
        loadMovies()
    }
        
    private func loadMovies() {
        repository.getMovies(filter: currentFilter, page: currentPage) { [weak self] dto in
            guard let self else {
               return
            }
            self.totalPages = dto.totalPages
            let newMovies = dto.items.map { dtoItem in
                /* CODEREVIEW:
                 Отформатировать переносы

                 И return здесь не обязателен, как и явный захват dtoItem,
                 можно просто так:

                 MovieListItemModel(
                     kinopoiskID: $0.kinopoiskID,
                     title: $0.getName,
                     genre: $0.genres.map({$0.genre}).joined(separator: ", "),
                     year: $0.year,
                     country: $0.countries.map{$0.country}.joined(separator: ", "),
                     rating: $0.ratingKinopoisk,
                     posterUrlPreview: $0.posterURLPreview
                 )
                 */
                return MovieListItemModel(
                    kinopoiskID: dtoItem.kinopoiskID,
                    title: dtoItem.getName,
                    genre: dtoItem.genres.map({$0.genre}).joined(separator: ", "),
                    year: dtoItem.year,
                    country: dtoItem.countries.map{$0.country}.joined(separator: ", "),
                    rating: dtoItem.ratingKinopoisk,
                    posterUrlPreview: dtoItem.posterURLPreview
                )
            }
            self.isFooterViewPresented = false
            self.movies.append(contentsOf: newMovies)
            self.handleSearch(searchRequest)
        }
    }
    
    private func loadFirstPage() {
        currentPage = 1
        movies = []
        loadMovies()
    }
}



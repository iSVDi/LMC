//
//  MoviesPresenter.swift
//  LMS
//
//  Created by Daniil on 12.09.2024.
//

import UIKit

class MoviesPresenter {
    private weak var moviesViewControllerDelegate: MoviesViewControllerDelegate?
    private let movieRepository = MoviesRepository()
    private var movieList = MovieListModel()
    private(set) var filteredMovieList: [MovieListItemModel] = []
    private(set) var selectedYearId: Int = 2
    private(set) var currentPage = 1
    
    private var searchRequest = ""
    private(set) var years = Array((1950...2026).reversed())
    
    init(moviesViewControllerDelegate: MoviesViewControllerDelegate) {
        self.moviesViewControllerDelegate = moviesViewControllerDelegate
    }
    
    func handleViewDidLoad() {
        updateMovie(order: .rating, year: years[selectedYearId])
    }
    
    func updateMovie(order: MoviesOrder, year: Int) {
        movieRepository.getMovies(order: order, year: year, page: currentPage) { [weak self] movieList in
            guard let welf = self else {
                return
            }
            welf.movieList = movieList
            welf.filteredMovieList = movieList.items
            welf.handleFilterBySearch(welf.searchRequest)
        }
    }
    
    func handleSelectYearFilter(_ id: Int) {
        selectedYearId = id
        updateMovie(order: .year, year: years[id])
    }
    
    
    func handleSortByRating() {
        updateMovie(order: .rating, year: years[selectedYearId])
    }
    
    func handleFilterBySearch(_ search: String) {
        searchRequest = search
        guard !search.isEmpty else {
            filteredMovieList = movieList.items
            moviesViewControllerDelegate?.reloadTableView()
            return
        }
        
        filteredMovieList = movieList.items.filter { model in
            let lowerCasedSearch = search.lowercased()
            return model.getName.lowercased().contains(lowerCasedSearch) ||
            model.genres.contains(where: {$0.genre.lowercased().contains(lowerCasedSearch)}) ||
            model.countries.contains(where: {$0.country.lowercased().contains(lowerCasedSearch)})
        }
        moviesViewControllerDelegate?.reloadTableView()
        
    }
    
    func handleRefresh() {
        handleSortByRating()
    }
    
    func stepForward() {
        guard currentPage < movieList.totalPages else {
            return
        }
        currentPage += 1
        updateMovie(order: .rating, year: years[selectedYearId])
        
    }
    
    func stepBack() {
        guard currentPage > 1  else {
            return
        }
        currentPage -= 1
        updateMovie(order: .rating, year: years[selectedYearId])
    }
    
    
    func exitButtonTapped() {
        let controller = AuthViewController()
        let navigation = UINavigationController(rootViewController: controller)
        navigation.modalPresentationStyle = .fullScreen
        moviesViewControllerDelegate?.exitWith(navigation)
    }
    
    func handleMovieTapWith(_ id: Int) {
        let movieId = movieList.items[id].kinopoiskID
        
        let movieDetailsViewController = MovieDetailsViewController()
        let movieDetailsPresenter = MovieDetailsPresenter(movieID: movieId,
                                                          movieDetailsDelegate: movieDetailsViewController)
        movieDetailsViewController.setPresent(movieDetailsPresenter)
        moviesViewControllerDelegate?.pushController(movieDetailsViewController)
    }
    
}

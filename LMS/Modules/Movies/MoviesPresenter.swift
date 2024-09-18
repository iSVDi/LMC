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
    private let userDefaultManager = UserDefaultManager()
    private var movieList = MovieListModel()
    private(set) var filteredMovieList: [MovieListItemModel] = []
    private(set) var selectedYearId: Int = 0
    private(set) var currentPage = 1
    private let moviesPerPage = 20
    private var descOrder = true
    private var searchRequest = ""
    private(set) var years = Array((1950...2024).reversed())
    
    init(moviesViewControllerDelegate: MoviesViewControllerDelegate) {
        self.moviesViewControllerDelegate = moviesViewControllerDelegate
    }
    
    var isNeedDisplayLoadingFooterView: Bool {
        return currentPage + 1 <= movieList.totalPages
    }
    
    private var getLastMovieCellId: Int { return (20 * currentPage) - 1 }
    
    //MARK: - Interface
    
    func handleViewDidLoad() {
        guard !userDefaultManager.getBool(key: .isNeedSignIn) else {
            presentAuthController(animated: false)
            return
        }
        updateMoviesWithLoading()
    }
    
    func handleSelectYearFilter(_ id: Int) {
        selectedYearId = id
        loadFirstPage()
    }
    
    
    func handleSortByRating() {
        descOrder.toggle()
        movieList.items.reverse()
        filteredMovieList.reverse()
        moviesViewControllerDelegate?.reloadTableView()
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
        loadFirstPage()
    }
        
    func exitButtonTapped() {
        currentPage = 1
        selectedYearId = 0
        userDefaultManager.setBool(value: true, key: .isNeedSignIn)
        presentAuthController(animated: true)
    }
    
    func handleMovieTapWith(_ id: Int) {
        let movieId = movieList.items[id].kinopoiskID
        
        let movieDetailsViewController = MovieDetailsViewController()
        let movieDetailsPresenter = MovieDetailsPresenter(movieID: movieId,
                                                          movieDetailsDelegate: movieDetailsViewController)
        movieDetailsViewController.setPresent(movieDetailsPresenter)
        moviesViewControllerDelegate?.pushController(movieDetailsViewController)
    }
    
    func handleWillDisplayTableViewCell(with id: Int) {
        guard id == getLastMovieCellId && isNeedDisplayLoadingFooterView else {
            return
        }
        currentPage += 1
        updateMovie(order: .rating, year: years[selectedYearId])
    }
    
    //MARK: - Private methods
    
    private func presentAuthController(animated: Bool) {
        let controller = AuthViewController() { [weak self] in
            self?.updateMoviesWithLoading()
        }
        
        controller.modalPresentationStyle = .fullScreen
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        rootViewController?.present(controller, animated: animated)
    }
    
    private func updateMoviesWithLoading() {
        moviesViewControllerDelegate?.setLoading(true)
        updateMovie(order: .rating, year: years[selectedYearId])
    }
    
    private func updateMovie(order: MoviesOrder, year: Int) {
        movieRepository.getMovies(order: order, year: year, page: currentPage) { [weak self] movieList in
            guard let welf = self else {
                return
            }
            
            if welf.currentPage > 1 {
                var sortedNewMovies = movieList.items.sorted { a, b in
                    if welf.descOrder {
                        return a.ratingKinopoisk > b.ratingKinopoisk
                    }
                    return a.ratingKinopoisk < b.ratingKinopoisk
                }
                
                
                if welf.descOrder {
                    welf.movieList.items.append(contentsOf: sortedNewMovies)
                } else {
                    welf.movieList.items.insert(contentsOf: sortedNewMovies, at: 0)
                }
                
                
            } else {
                welf.movieList = movieList
            }
            
            welf.filteredMovieList = movieList.items
            welf.moviesViewControllerDelegate?.setLoading(false)
            welf.handleFilterBySearch(welf.searchRequest)
        }
    }
    
    private func loadFirstPage() {
        currentPage = 1
        updateMovie(order: .rating, year: years[selectedYearId])
    }
    
}

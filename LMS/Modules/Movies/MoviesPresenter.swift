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
    private var movieList: [MovieListItemModel] = []
    private(set) var filteredMovieList: [MovieListItemModel] = []
    private var totalPages = 0
    private(set) var currentPage = 1
    private var searchRequest = ""
    private var filterDTO: MovieFilterDTO = .rating
    init(moviesViewControllerDelegate: MoviesViewControllerDelegate) {
        self.moviesViewControllerDelegate = moviesViewControllerDelegate
    }
    
    var isNeedDisplayLoadingFooterView: Bool {
        return currentPage + 1 <= totalPages
    }
    
    private var getLastMovieCellId: Int { return movieList.count - 1 }
    
    //MARK: - Interface
    
    func handleViewDidLoad() {
        guard !userDefaultManager.getBool(key: .isNeedSignIn) else {
            presentAuthController(animated: false)
            return
        }
        updateMoviesWithLoading()
    }
    
    func handleFilterBySearch(_ search: String) {
        searchRequest = search
        guard !search.isEmpty else {
            filteredMovieList = movieList
            moviesViewControllerDelegate?.reloadTableView()
            return
        }
        
        filteredMovieList = movieList.filter { model in
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
        userDefaultManager.setBool(value: true, key: .isNeedSignIn)
        filterDTO = .rating
        presentAuthController(animated: true)
    }
    
    func handleMovieTapWith(_ id: Int) {
        let movieId = movieList[id].kinopoiskID
        
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
        updateMovie()
    }
    
    func handleDoFilter(filter: MovieFilterDTO) {
        self.filterDTO = filter
        moviesViewControllerDelegate?.setLoading(true)
        loadFirstPage()
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
        updateMovie()
    }
    
    
    private func updateMovie() {
        movieRepository.getMovies(filter: filterDTO, page: currentPage) { [weak self] movieList in
            guard let self else {
                return
            }
            self.movieList.append(contentsOf: movieList.items)
            self.totalPages = movieList.totalPages
            self.moviesViewControllerDelegate?.setLoading(false)
            self.handleFilterBySearch(self.searchRequest)
        }
    }
    
    private func loadFirstPage() {
        currentPage = 1
        movieList = []
        updateMovie()
    }
    
}

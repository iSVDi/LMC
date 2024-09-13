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
    private(set) var movieList = MovieListModel()
    
    init(moviesViewControllerDelegate: MoviesViewControllerDelegate) {
        self.moviesViewControllerDelegate = moviesViewControllerDelegate
    }
    
    func handleViewDidLoad() {
        movieRepository.getMovies { [weak self] movieList in
            self?.movieList = movieList
            self?.moviesViewControllerDelegate?.reloadTableView()
        }
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
        moviesViewControllerDelegate?.presentController(movieDetailsViewController)
    }
    
}

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
    
    
    init(moviesViewControllerDelegate: MoviesViewControllerDelegate) {
        self.moviesViewControllerDelegate = moviesViewControllerDelegate
    }
    
    func handleViewDidLoad() {
        movieRepository.getMovies { movieList in
            
            //TODO: update ViewController
        }
    }
    
    func exitButtonTapped() {
        let controller = AuthViewController()
        let navigation = UINavigationController(rootViewController: controller)
        navigation.modalPresentationStyle = .fullScreen
        moviesViewControllerDelegate?.exitWith(navigation)
    }
    
}

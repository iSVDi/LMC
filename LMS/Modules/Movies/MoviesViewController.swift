//
//  MoviesViewController.swift
//  LMS
//
//  Created by Daniil on 11.09.2024.
//

import Foundation
import UIKit

protocol MoviesViewControllerDelegate: AnyObject {
    func exitWith(_ controller: UINavigationController)
}

class MoviesViewController: UIViewController, MoviesViewControllerDelegate {
    
    private lazy var presenter = MoviesPresenter(moviesViewControllerDelegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        self.navigationItem.setHidesBackButton(true, animated: false)
        setupNavigationBar()
    }
    
    func exitWith(_ controller: UINavigationController) {
        present(controller, animated: true)
    }
    
    //TODO: localize image?
    private func setupNavigationBar() {
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(rightBarButtonHandler))
        navigationItem.setRightBarButton(rightButton, animated: false)
    }
    
    @objc
    private func rightBarButtonHandler() {
        presenter.exitButtonTapped()
    }
}

//
//  AuthPresenter.swift
//  LMS
//
//  Created by Daniil on 11.09.2024.
//

import Foundation
import UIKit

class AuthPresenter {
    private weak var authController: AuthViewControllerDelegate?
    private let userDefaultManager = UserDefaultManager()
    
    init(authController: AuthViewControllerDelegate) {
        self.authController = authController
    }
    
    func signIn(login: String, password: String) {
      
        guard let userLogin = userDefaultManager.getString(key: .login),
              let userPassword = userDefaultManager.getString(key: .password) else {
            userDefaultManager.setString(value: login, key: .login)
            userDefaultManager.setString(value: password, key: .password)
            presentMovies()
            return
        }
        
        if (userLogin == login && userPassword == password) {
            presentMovies()
            return
        }
        authController?.showAlert()
        
    }
    
    private func presentMovies() {
        let moviesController = MoviesViewController()
        let navigation = UINavigationController(rootViewController: moviesController)
        navigation.modalPresentationStyle = .fullScreen
        authController?.presentController(navigation)
    }

}

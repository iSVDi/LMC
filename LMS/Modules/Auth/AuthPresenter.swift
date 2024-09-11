//
//  AuthPresenter.swift
//  LMS
//
//  Created by Daniil on 11.09.2024.
//

import Foundation
class AuthPresenter {
    private weak var authController: AuthViewController!
    private let userDefaultManager = UserDefaultManager()
    
    init(authController: AuthViewController) {
        self.authController = authController
    }
    
    func saveUser(login: String, password: String) {
        userDefaultManager.setString(value: login, key: .login)
        userDefaultManager.setString(value: password, key: .password)
        

        let moviesController = MoviesViewController()
        moviesController.modalPresentationStyle = .fullScreen
        authController.present(moviesController, animated: true)
    }
}

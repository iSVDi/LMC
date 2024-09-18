//
//  AuthPresenter.swift
//  LMS
//
//  Created by Daniil on 11.09.2024.
//

import Foundation
import UIKit

class AuthPresenter {
    private weak var authControllerDelegate: AuthViewControllerDelegate?
    private let userDefaultManager = UserDefaultManager()
    
    init(authController: AuthViewControllerDelegate) {
        self.authControllerDelegate = authController
    }
    
    func signIn(login: String, password: String) {
        guard let userLogin = userDefaultManager.getString(key: .login),
              let userPassword = userDefaultManager.getString(key: .password) else {
            userDefaultManager.setString(value: login, key: .login)
            userDefaultManager.setString(value: password, key: .password)
            dismissController()
            return
        }
        
        if (userLogin == login && userPassword == password) {
            dismissController()
            return
        }
        authControllerDelegate?.showAlert()
        
    }
    
    private func dismissController() {
        userDefaultManager.setBool(value: false, key: .isNeedSignIn)
        authControllerDelegate?.dismissController()
    }

}

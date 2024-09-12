//
//  AuthService.swift
//  LMS
//
//  Created by Daniil on 11.09.2024.
//

import Foundation
import UIKit
class AuthService {
    private let userDefaultManager = UserDefaultManager()
    
    func getController() -> UIViewController {
        guard let _ = userDefaultManager.getString(key: .login) else {
            return AuthViewController()
        }
        return MoviesViewController()
    }

}

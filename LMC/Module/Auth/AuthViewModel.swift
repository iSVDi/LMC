//
//  AuthViewModel.swift
//  LMC
//
//  Created by daniil on 23.09.2024.
//

import SwiftUI

class AuthViewModel: ObservableObject {
    private let authDataManager = AuthDataManager.shared
    @Published var isPresentAlert = false
    private(set) var alertMessage = ""
    
    func handleAuthButton(login: String, password: String) {
        authDataManager.auth(login: login, password: password) { [weak self] message in
            self?.alertMessage = message
            self?.isPresentAlert.toggle()
            
        }
    }
    
}



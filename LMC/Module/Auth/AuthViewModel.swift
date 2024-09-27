//
//  AuthViewModel.swift
//  LMC
//
//  Created by daniil on 23.09.2024.
//

import SwiftUI

final class AuthViewModel: ObservableObject {
    private var authDataManager: AuthDataManager
    @Published var isPresentAlert: Bool
    private(set) var alertMessage: String
    
    init(
        authDataManager: AuthDataManager = AuthDataManager.shared,
        isPresentAlert: Bool = false,
        alertMessage: String = ""
    ) {
        self.authDataManager = authDataManager
        self.isPresentAlert = isPresentAlert
        self.alertMessage = alertMessage
    }
    
    func handleAuthButton(login: String, password: String) {
        authDataManager.auth(login: login, password: password) { [weak self] message in
            self?.alertMessage = message
            self?.isPresentAlert.toggle()
        }
    }
    
}

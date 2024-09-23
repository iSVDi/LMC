//
//  AuthViewModel.swift
//  LMC
//
//  Created by daniil on 23.09.2024.
//

import SwiftUI

class AuthViewModel: ObservableObject {
    private let userDefaultManager = UserDefaultManager()
    @Published var isPresentAlert = false
    @Published private(set) var isNeedDissmiss = false
    
    func handleAuthButton(login: String, password: String) {
        guard let userLogin = userDefaultManager.getString(key: .login),
              let userPassword = userDefaultManager.getString(key: .password) else {
            userDefaultManager.setString(value: login, key: .login)
            userDefaultManager.setString(value: password, key: .password)
            //TODO: close view
            dismiss()
            return
        }
        
        if (userLogin == login && userPassword == password) {
            dismiss()
            return
        }
        isPresentAlert.toggle()
    }
    
    private func dismiss() {
        userDefaultManager.setBool(value: false, key: .isNeedSignIn)
        isNeedDissmiss = true
    }
    
}



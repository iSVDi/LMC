//
//  AuthViewModel.swift
//  LMC
//
//  Created by daniil on 23.09.2024.
//

import SwiftUI

class AuthViewModel: ObservableObject {
    /* CODEREVIEW:
     Здесь вместо UserDefaultManager будет AuthService
     */
    private let userDefaultManager = UserDefaultManager()
    @Published var isPresentAlert = false
    @Published private(set) var isNeedDissmiss = false
    
    func handleAuthButton(login: String, password: String) {
        /* CODEREVIEW:
         Эту логику нужно будет вынести в AuthService
         */
        guard let userLogin = userDefaultManager.getString(key: .login),
              let userPassword = userDefaultManager.getString(key: .password) else {
            userDefaultManager.setString(value: login, key: .login)
            userDefaultManager.setString(value: password, key: .password)
            //TODO: close view
            dismiss()
            return
        }
        
        /* CODEREVIEW:
         Давай слегка усложним задачку:

         Сделай так, чтобы писалась конкретная ошибка, что неверно - пароль или логин, или все вместе
         */
        if (userLogin == login && userPassword == password) {
            dismiss()
            return
        }
        isPresentAlert.toggle()
    }
    
    /* CODEREVIEW:
     В методе dismiss отпадет необходимость, когда LMCApp начнет слушать состояние авторизации
     */
    private func dismiss() {
        userDefaultManager.setBool(value: false, key: .isNeedSignIn)
        isNeedDissmiss = true
    }
    
}



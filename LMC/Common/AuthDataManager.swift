//
//  AuthDataManager.swift
//  LMC
//
//  Created by daniil on 24.09.2024.
//

import Combine

class AuthDataManager {
    static let shared = AuthDataManager()
    private let userDefaultsManager = UserDefaultsManager()
    private let isNeedSignInSubject: CurrentValueSubject<Bool, Never>
    private var subscriptions: Set<AnyCancellable> = []
    
    private init() {
        let state = userDefaultsManager.getBool(key: .isNeedSignIn)
        isNeedSignInSubject = CurrentValueSubject<Bool, Never>(state)
    }
    
    var isNeedSignIn: Bool {
        get {
            return isNeedSignInSubject.value
        } set {
            isNeedSignInSubject.value = newValue
            isNeedSignInSubject.send(newValue)
            userDefaultsManager.setBool(value: newValue, key: .isNeedSignIn)
        }
    }
    
    func sink(receiveValue: @escaping ((Bool) -> Void)) {
        isNeedSignInSubject.sink(receiveValue: receiveValue).store(in: &subscriptions)
    }
    
    func auth(login: String,
              password: String,
              errorHandler: @escaping (_ message: String)->()) {
        
        guard let userLogin = userDefaultsManager.getString(key: .login),
              let userPassword = userDefaultsManager.getString(key: .password) else {
            userDefaultsManager.setString(value: login, key: .login)
            userDefaultsManager.setString(value: password, key: .password)
            isNeedSignIn = false
            return
        }
                
        let areLoginsIncorrectMessage = areLoginsIncorrect(userLogin: userLogin, login: login)
        let arePasswordsIncorrectMessage = arePasswordsIncorrect(userPassword: userPassword, password: password)
        
        guard areLoginsIncorrectMessage != nil || arePasswordsIncorrectMessage != nil else {
            isNeedSignIn = false
            return
        }
        
        let message = getErrorMessage(loginIncorrectMessage: areLoginsIncorrectMessage,
                                      passwordIncorrectMessage: arePasswordsIncorrectMessage)
        errorHandler(message)
        
    }
    
    private func getErrorMessage(loginIncorrectMessage: String?, passwordIncorrectMessage: String?) -> String {
        if let loginsMessage = loginIncorrectMessage, let passwordMessage = passwordIncorrectMessage {
            return [loginsMessage, passwordMessage].joined(separator: ". ")
            
        }
        
        if let loginsMessage = loginIncorrectMessage {
            return loginsMessage
        }
        
        if let passwordMessage = passwordIncorrectMessage {
            return passwordMessage
        }
        
        return "unknown error"
    }
    
    
    private func areLoginsIncorrect(userLogin: String, login: String) -> String? {
        if (userLogin != login) {
            return "Logins are mismatched"
        }
        return nil
    }
    
    private func arePasswordsIncorrect(userPassword: String, password: String) -> String? {
        if (userPassword != password) {
            return "Passwords are mismatched"
        }
        return nil
    }
    
}

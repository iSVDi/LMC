//
//  AuthDataManager.swift
//  LMC
//
//  Created by daniil on 24.09.2024.
//

import Combine

final class AuthDataManager {
    static let shared = AuthDataManager(userDefaults: UserDefaultsProtocolImpl())
    private let userDefaults: UserDefaultsProtocol
    private let isNeedSignInSubject: CurrentValueSubject<Bool, Never>
    
    private init(userDefaults: UserDefaultsProtocol) {
        self.userDefaults = userDefaults
        userDefaults.register(defaults: [UserDataKeys.isNeedSignIn.rawValue: true])
        let state = userDefaults.bool(key: .isNeedSignIn)
        isNeedSignInSubject = CurrentValueSubject<Bool, Never>(state)
    }
    
    static func getInstance(userDefaults: UserDefaultsProtocol) -> AuthDataManager {
        return AuthDataManager(userDefaults: userDefaults)
    }
    
    var isNeedSignIn: Bool {
        get {
            return isNeedSignInSubject.value
        } set {
            isNeedSignInSubject.value = newValue
            isNeedSignInSubject.send(newValue)
            userDefaults.setValue(newValue, key: .isNeedSignIn)
        }
    }
    
    func sink(receiveValue: @escaping ((Bool) -> Void)) -> AnyCancellable {
        return isNeedSignInSubject.sink(receiveValue: receiveValue)
    }
    
    func auth(
        login: String,
        password: String,
        errorHandler: @escaping (_ message: String) -> Void
    ) {
        
        guard let userLogin = userDefaults.string(key: .login),
              let userPassword = userDefaults.string(key: .password) else {
            userDefaults.setValue(login, key: .login)
            userDefaults.setValue(password, key: .password)
            isNeedSignIn = false
            return
        }
        
        let areLoginsIncorrectMessage = areLoginsIncorrect(userLogin: userLogin, login: login)
        let arePasswordsIncorrectMessage = arePasswordsIncorrect(userPassword: userPassword, password: password)
        
        
        guard let errorMessage = getErrorMessage(loginIncorrectMessage: areLoginsIncorrectMessage,
                                                 passwordIncorrectMessage: arePasswordsIncorrectMessage) else {
            isNeedSignIn = false
            return
        }

        errorHandler(errorMessage)
    }
    
    private func getErrorMessage(loginIncorrectMessage: String?, passwordIncorrectMessage: String?) -> String? {
        if let loginsMessage = loginIncorrectMessage, let passwordMessage = passwordIncorrectMessage {
            return [loginsMessage, passwordMessage].joined(separator: ". ")
            
        }
        
        if let loginsMessage = loginIncorrectMessage {
            return loginsMessage
        }
        
        if let passwordMessage = passwordIncorrectMessage {
            return passwordMessage
        }
        
        return nil
    }
    
    private func areLoginsIncorrect(userLogin: String, login: String) -> String? {
        userLogin != login ? AppStrings.wrongLoginTitle : nil
    }
    
    private func arePasswordsIncorrect(userPassword: String, password: String) -> String? {
        userPassword != password ? AppStrings.wrongPasswordTitle : nil
    }
    
}

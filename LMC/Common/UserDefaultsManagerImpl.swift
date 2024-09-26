//
//  UserDefaultsManagerImpl.swift
//  LMS
//
//  Created by Daniil on 11.09.2024.
//

import Foundation

enum UserDataKeys: String {
    case login
    case password
    case isNeedSignIn
}

protocol UserDefaultsManagerProtocol {
    func getString(key: UserDataKeys) -> String?
    func setString(value: String, key: UserDataKeys)
    func getBool(key: UserDataKeys) -> Bool
    func setBool(value: Bool, key: UserDataKeys)
}

final class UserDefaultsManagerImpl: UserDefaultsManagerProtocol {
    private let userDefaults = UserDefaults.standard
    
    init() {
        userDefaults.register(defaults: [UserDataKeys.isNeedSignIn.rawValue: true])
    }
    
    func getString(key: UserDataKeys) -> String? {
        return userDefaults.string(forKey: key.rawValue)
    }
    
    func setString(value: String, key: UserDataKeys) {
        userDefaults.setValue(value, forKey: key.rawValue)
    }
    
    func getBool(key: UserDataKeys) -> Bool {
        return userDefaults.bool(forKey: key.rawValue)
    }
    
    func setBool(value: Bool, key: UserDataKeys) {
        userDefaults.setValue(value, forKey: key.rawValue)
    }
    
}

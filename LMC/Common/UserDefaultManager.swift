//
//  UserDetails.swift
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

class UserDefaultManager {
    private let userDefault = UserDefaults()
    
    init() {
        userDefault.register(defaults: [UserDataKeys.isNeedSignIn.rawValue : true])
    }
    
    func getString(key: UserDataKeys) -> String? {
        return userDefault.string(forKey: key.rawValue)
    }
    
    func setString(value: String, key: UserDataKeys) {
        userDefault.setValue(value, forKey: key.rawValue)
    }
    
    func getBool(key: UserDataKeys) -> Bool {
        return userDefault.bool(forKey: key.rawValue)
    }
    
    func setBool(value: Bool, key: UserDataKeys) {
        userDefault.setValue(value, forKey: key.rawValue)
    }
    
}

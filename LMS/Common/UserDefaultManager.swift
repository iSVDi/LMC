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
}

class UserDefaultManager {
    private let userDefault = UserDefaults()
    
    func getString(key: UserDataKeys) -> String? {
        return userDefault.string(forKey: key.rawValue)
    }
    
    func setString(value: String, key: UserDataKeys) {
        userDefault.setValue(value, forKey: key.rawValue)
    }
    
}

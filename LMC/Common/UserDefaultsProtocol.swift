//
//  UserDefaultsProtocol.swift
//  LMC
//
//  Created by daniil on 26.09.2024.
//

import Foundation

enum UserDataKeys: String {
    case login
    case password
    case isNeedSignIn
}

protocol UserDefaultsProtocol {
    func register(defaults: [String: Any])
    func string(key: UserDataKeys) -> String?
    func bool(key: UserDataKeys) -> Bool
    func setValue(_ value: Any, key: UserDataKeys)
}

final class UserDefaultsProtocolImpl: UserDefaultsProtocol {
    private let userDefaults = UserDefaults.standard
    
    func register(defaults: [String : Any]) {
        userDefaults.register(defaults: defaults)
    }
    
    func setValue(_ value: Any, key: UserDataKeys) {
        userDefaults.setValue(value, forKey: key.rawValue)
    }
    
    func string(key: UserDataKeys) -> String? {
        userDefaults.string(forKey: key.rawValue)
    }
    
    func bool(key: UserDataKeys) -> Bool {
        userDefaults.bool(forKey: key.rawValue)
    }
     
}

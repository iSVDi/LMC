//
//  MockUserDefaultsManagerImpl.swift
//  LMCUITests
//
//  Created by daniil on 26.09.2024.
//

@testable import LMC

class MockUserDefaultsManagerImpl: UserDefaultsProtocol {
    private(set) var mockUserDefaults: [String : Any] = [:]
    
    func string(key: LMC.UserDataKeys) -> String? {
        return mockUserDefaults[key.rawValue] as? String
    }
    
    func bool(key: LMC.UserDataKeys) -> Bool {
        return mockUserDefaults[key.rawValue] as? Bool ?? false
    }
    
    func setValue(_ value: Any, key: LMC.UserDataKeys) {
        mockUserDefaults[key.rawValue] = value
    }
    
    func register(defaults: [String : Any]) {
        mockUserDefaults = defaults
    }
    
}

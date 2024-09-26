//
//  MockUserDefaultsManagerImpl.swift
//  LMCUITests
//
//  Created by daniil on 26.09.2024.
//

@testable import LMC

class MockUserDefaultsManagerImpl: UserDefaultsManagerProtocol {
    private(set) var mockUserDefaults: [String : Any] = [LMC.UserDataKeys.isNeedSignIn.rawValue : true]
    
    func getString(key: LMC.UserDataKeys) -> String? {
        return mockUserDefaults[key.rawValue] as? String
    }
    
    func setString(value: String, key: LMC.UserDataKeys) {
        mockUserDefaults[key.rawValue] = value
    }
    
    func getBool(key: LMC.UserDataKeys) -> Bool  {
        return mockUserDefaults[key.rawValue] as? Bool ?? false
    }
    
    func setBool(value: Bool, key: LMC.UserDataKeys) {
        mockUserDefaults[key.rawValue] = value
    }
    
}

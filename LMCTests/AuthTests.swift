//
//  AuthTests.swift
//  AuthTests
//
//  Created by daniil on 25.09.2024.
//

import XCTest
@testable import LMC
final class AuthTests: XCTestCase {
    private var userDefaultsManager: UserDefaultsManagerProtocol = MockUserDefaultsManagerImpl()
    private let login = "test_login"
    private let password = "test_Password"
    
    func testIsNeedLoginIsTrueDefault() {
        XCTAssertTrue(userDefaultsManager.getBool(key: .isNeedSignIn))
    }
    
    func testEnterLogin()  {
        userDefaultsManager.setString(value: login, key: .login)
        XCTAssertNotNil(userDefaultsManager.getString(key: .login), "Login should be not nil")
    }
    
    func testEnterPassword()  {
        userDefaultsManager.setString(value: password, key: .password)
        XCTAssertNotNil(userDefaultsManager.getString(key: .password), "Password should be not nil")
    }
    
    func testEnterAfterSuccessRegister() {
        userDefaultsManager.setBool(value: false, key: .isNeedSignIn)
        XCTAssertFalse(userDefaultsManager.getBool(key: .isNeedSignIn))
    }
    
}

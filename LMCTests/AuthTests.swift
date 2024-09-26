//
//  AuthTests.swift
//  AuthTests
//
//  Created by daniil on 25.09.2024.
//

import XCTest
@testable import LMC

final class AuthTests: XCTestCase {
    private var userDefaults: UserDefaultsProtocol = MockUserDefaultsManagerImpl()
    private lazy var mockAuthDataManager = AuthDataManager.getMock(userDefaults: userDefaults)
    private let login = "test_login"
    private let password = "test_Password"
    
    func testIsNeedLoginIsTrueDefault() {
        userDefaults.register(defaults: [UserDataKeys.isNeedSignIn.rawValue: true])
        XCTAssertTrue(userDefaults.bool(key: UserDataKeys.isNeedSignIn))
    }
    
    func testEnterLogin()  {
        userDefaults.setValue(login, key: UserDataKeys.login)
        XCTAssertNotNil(userDefaults.string(key: UserDataKeys.login), "Login should be not nil")
    }
    
    func testEnterPassword()  {
        userDefaults.setValue(password, key: UserDataKeys.password)
        XCTAssertNotNil(userDefaults.string(key: UserDataKeys.password), "Password should be not nil")
    }
    
    func testEnterAfterSuccessRegister() {
        userDefaults.setValue(false, key: UserDataKeys.isNeedSignIn)
        XCTAssertFalse(userDefaults.bool(key: UserDataKeys.isNeedSignIn))
    }
    
    func testAuth() {
        XCTAssertTrue(mockAuthDataManager.isNeedSignIn)
        mockAuthDataManager.auth(login: login, password: password, errorHandler: {_ in})
        XCTAssertFalse(mockAuthDataManager.isNeedSignIn)
    }
    
    func testAuthWithEmptyLoginPassword() {
        var errorMessage = ""
        XCTAssertTrue(mockAuthDataManager.isNeedSignIn)
        mockAuthDataManager.auth(login: login, password: password, errorHandler: {_ in})
        mockAuthDataManager.auth(login: "", password: "", errorHandler: {errorMessage = $0})
        XCTAssertEqual(errorMessage, "Logins are mismatched. Passwords are mismatched")
        XCTAssertFalse(mockAuthDataManager.isNeedSignIn)
    }
    
}

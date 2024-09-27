//
//  AuthDataManagerTestCase.swift
//  LMCUITests
//
//  Created by daniil on 25.09.2024.
//

import XCTest
@testable import LMC

final class AuthDataManagerTestCase: XCTestCase {
    private var mockAuthDataManager: AuthDataManager!
    private var login: String!
    private var password: String!
    private var wrongLogin: String!
    private var wrongPassword: String!
    
    override func setUp() {
        super.setUp()
        mockAuthDataManager = AuthDataManager.getInstance(userDefaults: MockUserDefaultsManagerImpl())
        login = "test_login"
        password = "test_Password"
        wrongLogin = "asdasd"
        wrongPassword = "asdasd"
    }
    
    func testIsNeedSignIn() {
        XCTAssertTrue(mockAuthDataManager.isNeedSignIn)
        mockAuthDataManager.auth(login: login, password: password, errorHandler: {_ in})
        XCTAssertFalse(mockAuthDataManager.isNeedSignIn)
    }
    
    func testRegister() {
        XCTAssertTrue(mockAuthDataManager.isNeedSignIn)
        var errorMessage = ""
        mockAuthDataManager.auth(login: login, password: password, errorHandler: {errorMessage = $0})
        XCTAssertFalse(mockAuthDataManager.isNeedSignIn)
        XCTAssertTrue(errorMessage.isEmpty)
    }
    
    func testAuth() {
        testRegister()
        mockAuthDataManager.isNeedSignIn = true
        
        var errorMessage = ""
        mockAuthDataManager.auth(login: login, password: password, errorHandler: {errorMessage = $0})
        XCTAssertFalse(mockAuthDataManager.isNeedSignIn)
        XCTAssertTrue(errorMessage.isEmpty)
    }
    
    func testAuthWrongLogin() {
        testRegister()
        var errorMessage = ""
        mockAuthDataManager.auth(login: wrongLogin, password: password, errorHandler: {errorMessage = $0})
        XCTAssertFalse(mockAuthDataManager.isNeedSignIn)
        XCTAssertEqual(errorMessage, AppStrings.wrongLoginTitle)
        
    }
    
    func testAuthWrongPassword() {
        testRegister()
        var errorMessage = ""
        mockAuthDataManager.auth(login: login, password: wrongPassword, errorHandler: {errorMessage = $0})
        XCTAssertFalse(mockAuthDataManager.isNeedSignIn)
        XCTAssertEqual(errorMessage, AppStrings.wrongPasswordTitle)
    }
    
    func testAuthEmptyLoginPassword() {
        testRegister()
        
        var errorMessage = ""
        mockAuthDataManager.auth(login: "", password: "", errorHandler: {errorMessage = $0})
        XCTAssertFalse(mockAuthDataManager.isNeedSignIn)
        var expectedErrorMessage = AppStrings.wrongLoginTitle + ". " + AppStrings.wrongPasswordTitle
        XCTAssertEqual(errorMessage, expectedErrorMessage)
    }
    
}

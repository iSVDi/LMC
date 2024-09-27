//
//  AuthViewModelTestCase.swift
//  LMCUITests
//
//  Created by daniil on 27.09.2024.
//

import XCTest
@testable import LMC

final class AuthViewModelTestCase: XCTestCase {
    private var mockAuthViewModel: AuthViewModel!
    private var login: String!
    private var password: String!
    private var wrongLogin: String!
    
    override func setUp() {
        let mockUserDefaults = MockUserDefaultsManagerImpl()
        mockUserDefaults.register(defaults: [UserDataKeys.isNeedSignIn.rawValue: false])
        let mockAuthDataManager = AuthDataManager.getInstance(userDefaults: mockUserDefaults)
        mockAuthViewModel = AuthViewModel(authDataManager: mockAuthDataManager)
        login = "test_Login"
        password = "test_Password"
        wrongLogin = "wrong_Login"
    }
    
    func testRegister() {
        mockAuthViewModel.handleAuthButton(login: login, password: password)
        XCTAssertTrue(mockAuthViewModel.alertMessage.isEmpty)
        XCTAssertFalse(mockAuthViewModel.isPresentAlert)
    }
    
    func testAuth() {
        testRegister()
        
        mockAuthViewModel.handleAuthButton(login: login, password: password)
        XCTAssertTrue(mockAuthViewModel.alertMessage.isEmpty)
        XCTAssertFalse(mockAuthViewModel.isPresentAlert)
    }
    
    func testAuthWrongLogin() {
        testRegister()
        
        mockAuthViewModel.handleAuthButton(login: wrongLogin, password: password)
        XCTAssertTrue(mockAuthViewModel.isPresentAlert)
        XCTAssertEqual(mockAuthViewModel.alertMessage, AppStrings.wrongLoginTitle)
        
    }
    
}

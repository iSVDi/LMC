//
//  AppViewModel.swift
//  LMC
//
//  Created by daniil on 24.09.2024.
//

import SwiftUI

class AppViewModel: ObservableObject {
    private let authDataManager = AuthDataManager.shared
    @Published var isNeedLogin: Bool
    
    init() {
        isNeedLogin = authDataManager.isNeedSignIn
        prepareForUse()
    }
    
    private func prepareForUse() {
        authDataManager.sink { [weak self] value in
            self?.isNeedLogin = value
        }
        
    }
    
}

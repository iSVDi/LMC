//
//  AppViewModel.swift
//  LMC
//
//  Created by daniil on 24.09.2024.
//

import SwiftUI
import Combine

final class AppViewModel: ObservableObject {
    private let authDataManager = AuthDataManager.shared
    private var subscriptions: Set<AnyCancellable> = []
    @Published var isNeedLogin: Bool
    
    init() {
        isNeedLogin = authDataManager.isNeedSignIn
        prepareForUse()
    }
    
    private func prepareForUse() {
        authDataManager.sink { [weak self] value in
            self?.isNeedLogin = value
        }.store(in: &subscriptions)
        
    }
}

//
//  LMCApp.swift
//  LMC
//
//  Created by daniil on 19.09.2024.
//

import SwiftUI

@main
struct LMCApp: App {
    @StateObject private var appViewModel = AppViewModel()
    var body: some Scene {
        WindowGroup {
            if appViewModel.isNeedLogin {
                AuthView()
            } else {
                MoviesView()
            }
        }
    }
}

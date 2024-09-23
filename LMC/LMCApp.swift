//
//  LMCApp.swift
//  LMC
//
//  Created by daniil on 19.09.2024.
//

import SwiftUI

@main
struct LMCApp: App {
    var body: some Scene {
        WindowGroup {
            /* CODEREVIEW:

             В SwiftUI приложениях распространен подход замены вьюх по условиям.
             Поэтому здесь можно было бы возвращать не всегда MoviesView, а либо AuthView, либо MoviewsView

             Создай AppViewModel, аналогично обычным вьюхам, в которой ты будешь проверять состояние авторизации
             и здесь использовать нужную вьюху

             Чтобы ты мог слушать состояние логина здесь, но менять его с другой вьюхи, можно реализовать
             AuthService, который хранил бы текущее состояния isLoggedIn как CurrentValueSubject,
             и на него бы ты подписывался в AppViewModel
             */
            MoviesView()
        }
    }
}

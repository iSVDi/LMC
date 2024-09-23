//
//  AuthView.swift
//  LMC
//
//  Created by daniil on 23.09.2024.
//

import SwiftUI

struct AuthView: View {
    @State private var loginText = ""
    @State private var passwordText = ""
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.appBlack
                    .ignoresSafeArea()
/* CODEREVIEW:
Спейсеры обычно нужны, чтобы заполнить динамически пространство между компонентами, чтобы оно было "максимальным"
 Сверху и снизу здесь такого не требуется. Можно было бы убрать первый и последний спейсеры и вместо этого сделать выравнивание по центру в ZStack

 Для Задания конкретного расстояния предпочтительнее использовать padding с нужным значением

 Также и Spacer() и, к примеру, title - это все вьюхи, расположенные на одном уровне, лучше им иметь одинаковую индентацию
 */
                VStack {
                    Spacer()
                        title
                    Spacer()
                        .frame(height: geometry.size.height * 0.1)
                        textFiels
                    Spacer()
                        authButton
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    /* CODEREVIEW:
     Вложенные вьюхи лучше делать приватными. Хороший подход - создать приватное расширение на текущую вью и там прописывать все вложенные
     */
    var title: some View {
        Text("KinoPoisk") //TODO: localize
            .foregroundStyle(Color.appColor)
            .font(.system(size: 60))
    }
    
    var textFiels: some View {
        VStack(spacing: 20) {
            //TODO: localize
            /* CODEREVIEW:
             Все модификаторы должны переноситься на новую строку для лучшей читабельности
             Перенеси .foregroundStyle тут и ниже

             Также хорошим UX считается указание типа контента для полей форм
             Например, username и password
             Делается это через модификатор .textContentType

             Так система сможет предложить тебе при вводе заполнить логин/пароль из сохраненных
             */
            TextField("Login", text: $loginText, prompt: Text("Login").foregroundStyle(Color.appGray))
                .padding(.all, 12)
                .foregroundStyle(Color.appWhite)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.appGray)
                }
            //TODO: localize
            /* CODEREVIEW:
             Пароль стоит делать закрытым маской

             В UIKit для этого использовалось свойство isSecureTextEntry, здесь же для этого есть
             отдельная вьюха - SecureField
             */
            TextField("Password", text: $passwordText, prompt: Text("Password").foregroundStyle(Color.appGray))
                .padding(.all, 12)
                .foregroundStyle(Color.appWhite)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.appGray)
                }
        }
    }
    
    var authButton: some View {
        Button {
            /* CODEREVIEW:
             Когда передалаешь на AuthService, убедись, что тут не будет двух вызовов методов, т.к.
             текущая реализация очень сильно зависит от синхронности кода
             */
            viewModel.handleAuthButton(login: loginText, password: passwordText)
            if viewModel.isNeedDissmiss {
                dismiss()
            }
            
        } label: {
            //TODO: localize
            Text("Войти")
                .foregroundStyle(Color.appWhite)
                .padding()
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(Color.appColor)
                }
            
        }
        .alert(isPresented: $viewModel.isPresentAlert) {
            //TODO: localize
            Alert(title: Text("Error"),
                  message: Text("Wrong login or password"))
                
        }
    }
}

#Preview {
    AuthView()
}

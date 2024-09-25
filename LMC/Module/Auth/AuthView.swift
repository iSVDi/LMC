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
            ZStack(alignment: .center) {
                Color.appBlack
                    .ignoresSafeArea()
                VStack {
                    title
                        .padding(.bottom, geometry.size.height * 0.1)
                    textFiels
                    authButton
                        .padding(.top, geometry.size.height * 0.2)
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

//MARK: - Private extension AuthView

private extension AuthView {
    var title: some View {
        Text(AppStrings.kinopoiskTitle)
            .foregroundStyle(Color.appColor)
            .font(.system(size: 60))
    }
    
    var textFiels: some View {
        VStack(spacing: 20) {

            TextField(AppStrings.loginTitle, text: $loginText, prompt: Text(AppStrings.loginTitle)
                .foregroundStyle(Color.appGray))
            .textContentType(.username)
            .padding(.all, 12)
            .foregroundStyle(Color.appWhite)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.appGray)
            }
            
            SecureField(AppStrings.passwordTitle, text: $passwordText, prompt: Text(AppStrings.passwordTitle)
                .foregroundStyle(Color.appGray))
            .textContentType(.password)
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
            viewModel.handleAuthButton(login: loginText, password: passwordText)
        } label: {
            Text(AppStrings.signInTitle)
                .foregroundStyle(Color.appWhite)
                .padding()
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(Color.appColor)
                }
        }
        .alert(isPresented: $viewModel.isPresentAlert) {
            Alert(title: Text(AppStrings.errorTitle),
                  message: Text(viewModel.alertMessage))
        }
    }
}

#Preview {
    AuthView()
}

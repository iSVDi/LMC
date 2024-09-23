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
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.appBlack
                    .ignoresSafeArea()
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
    
    var title: some View {
        Text("KinoPoisk") //TODO: localize
            .foregroundStyle(Color.appColor)
            .font(.system(size: 60))
    }
    
    var textFiels: some View {
        VStack(spacing: 20) {
            TextField("Login", text: $loginText, prompt: Text("Login").foregroundStyle(Color.appGray))
                .padding(.all, 12)
                .foregroundStyle(Color.appWhite)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.appGray)
                }
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
            dismiss()
        } label: {
            Text("Войти")
                .foregroundStyle(Color.appWhite)
                .padding()
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(Color.appColor)
                }
            
        }
    }
}

#Preview {
    AuthView()
}

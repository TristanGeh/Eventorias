//
//  LoginView.swift
//  Eventorias
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var isLoginMode = false
    @State private var isCreateMode = false
    
    var body: some View {
        VStack {
            Image("Logo", label: Text("Logo Eventorias"))
            
            Spacer()
            
            if isLoginMode {
                SignInView(viewModel: viewModel)
            } else if isCreateMode {
                CreateAccountView(viewModel: viewModel)
            }
            
            Button {
                if isLoginMode {
                    if viewModel.isValidEmail(viewModel.email) {
                        viewModel.login()
                    } else {
                        viewModel.errorMessage = "Invalid email format."
                    }
                } else if isCreateMode {
                    if viewModel.isValidEmail(viewModel.email) {
                        viewModel.signUp()
                    } else {
                        viewModel.errorMessage = "Invalid email format."
                    }
                } else {
                    isLoginMode = true
                }
            } label: {
                SignInButtonView(texte: isLoginMode ? "Sign In" : isCreateMode ? "Create Account" : "Sign in with email")
            }
            .padding()
            
            Button {
                if isCreateMode {
                    isCreateMode = false
                    isLoginMode = true
                } else {
                    isLoginMode = false
                    isCreateMode = true
                }
            } label: {
                Text(isCreateMode ? "Login here" : "Create an account here")
                    .foregroundColor(.white)
                    .underline()
            }
        }
        .padding(.top, 220)
        .padding(.bottom, 230)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Main"))
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    let viewModel = AuthViewModel()
    LoginView(viewModel: viewModel)
}

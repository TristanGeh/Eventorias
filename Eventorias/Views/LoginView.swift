//
//  LoginView.swift
//  Eventorias
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var isLoginMode = false
    
    var body: some View {
        VStack {
            Image("Logo", label: Text("Logo Eventorias"))
            
            Spacer()
            
            if isLoginMode {
                SignInView(viewModel: viewModel)
            }
            
            Button {
                if isLoginMode {
                    if viewModel.isValidEmail(viewModel.email) {
                        viewModel.login()
                    } else {
                        viewModel.errorMessage = "Invalid email format."
                    }
                }
            } label: {
                SignInButtonView(texte:"Sign in with email")
            }
            .padding()
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

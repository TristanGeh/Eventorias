//
//  CreateAccountView.swift
//  Eventorias
//

import SwiftUI

struct CreateAccountView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 50) {
            VStack(spacing: 20) {
                TextField("Email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
        .padding()
    }
}

#Preview {
    let viewModel = AuthViewModel()
    CreateAccountView(viewModel: viewModel)
}

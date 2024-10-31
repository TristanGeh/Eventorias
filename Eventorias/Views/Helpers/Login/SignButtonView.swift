//
//  SignButtonView.swift
//  Eventorias
//

import SwiftUI

struct SignInButtonView: View {
    var texte: String
    var body: some View {
        HStack {
            Image(systemName: "envelope.fill")
                .foregroundColor(.white)
            Text(texte)
                .foregroundColor(.white)
        }
        .padding([.bottom, .top], 10)
        .padding([.trailing, .leading], 7)
        .background(Color("MainRed"))
        .cornerRadius(5)
    }
}

#Preview {
    SignInButtonView(texte: "Sign in with email")
}

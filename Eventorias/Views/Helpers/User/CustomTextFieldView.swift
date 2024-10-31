//
//  CustomTextFieldView.swift
//  Eventorias
//

import SwiftUI

struct CustomTextFieldView: View {
    let title: String
    @Binding var text: String
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            TextField("", text: $text)
                .foregroundColor(.white)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(Color("SecondColor"))
        .cornerRadius(5)
    }
}


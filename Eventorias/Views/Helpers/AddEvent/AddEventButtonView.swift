//
//  AddEventButtonView.swift
//  Eventorias
//

import SwiftUI

struct AddEventButtonView: View {
    
    var body: some View {
        Image(systemName: "plus")
            .resizable()
            .frame(width: 18, height: 18)
            .foregroundColor(.white)
            .font(.system(size: 18, weight: .bold))
            .frame(width: 56, height: 56)
            .background(Color("MainRed"))
            .cornerRadius(15)
    }
}

#Preview {
    AddEventButtonView()
}

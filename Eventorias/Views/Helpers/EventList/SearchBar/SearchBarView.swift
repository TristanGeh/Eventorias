//
//  SearchBarView.swift
//  Eventorias
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack(spacing: 2){
            Image(systemName: "magnifyingglass")
            TextField("", text: $searchText, prompt: Text("Search").foregroundColor(.white))
                
        }
        .padding(5)
        .padding(.leading, 7)
        .foregroundColor(.white)
        .background(Color("SecondColor"))
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

#Preview {
    SearchBarView(searchText: .constant(""))
}

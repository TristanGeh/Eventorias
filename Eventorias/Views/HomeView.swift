//
//  ContentView.swift
//  Eventorias
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        NavigationStack {
            if viewModel.isConnected {
                EventView()
            } else {
                LoginView(viewModel: viewModel)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Main"))
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    HomeView()
}

//
//  HomeView.swift
//  Eventorias
//

import SwiftUI

enum Tab {
    case events
    case profile
}

struct EventView: View {
    @State private var selectedTab: Tab = .events
    @StateObject private var eventListViewModel = EventListViewModel()
    @StateObject private var userViewModel = UserViewModel()
    
    
    var body: some View {
        ZStack {
            Color("Main")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if selectedTab == .events {
                    EventContentView()
                        .environmentObject(eventListViewModel)
                } else {
                    UserProfileView()
                        .environmentObject(userViewModel)
                }
                
                Spacer()
            }
        }
        
        PickerView(selectedTab: $selectedTab)
    }
}

#Preview {
    EventView()
}

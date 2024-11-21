//
//  PickerView.swift
//  Eventorias
//

import SwiftUI

struct PickerView: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack(spacing: 14) {
            Button {
                selectedTab = .events
            } label: {
                VStack {
                    Image(systemName: "calendar")
                        .foregroundColor(selectedTab == .events ? .mainRed : .white)
                    Text("Events")
                        .foregroundColor(selectedTab == .events ? .mainRed : .white)
                }
            }
            .frame(maxWidth: .infinity)
            
            Button {
                selectedTab = .profile
            } label: {
                VStack {
                    Image(systemName: "person")
                        .foregroundColor(selectedTab == .profile ? .mainRed : .white)
                    Text("Profile")
                        .foregroundColor(selectedTab == .profile ? .mainRed : .white)

                }
            }
            .frame(maxWidth: .infinity)
            
        }
        .padding(.horizontal, 100)
        .padding(.vertical, 10)
        .background(Color("Main").edgesIgnoringSafeArea(.bottom))
    }
}

#Preview {
    @Previewable @State var selectedTab: Tab = .events
    PickerView(selectedTab: $selectedTab)
}

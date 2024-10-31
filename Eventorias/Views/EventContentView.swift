//
//  EventContentView.swift
//  Eventorias
//

import SwiftUI

struct EventContentView: View {
    @EnvironmentObject var eventListViewModel: EventListViewModel
    
    var body: some View {
        ZStack {
            VStack {
                SearchBarView(searchText: $eventListViewModel.searchText)
                
                ScrollView {
                    EventListView()
                        .environmentObject(eventListViewModel)
                }
                .onAppear {
                    print("Je suis appelé")
                    eventListViewModel.fetchEvents()
                }
                
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink {
                        AddEventView()
                    } label: {
                        AddEventButtonView()
                            .padding()
                    }

                }
            }
        }
    }
}

#Preview {
    let viewModel = EventListViewModel()
    EventContentView()
        .environmentObject(viewModel)
}

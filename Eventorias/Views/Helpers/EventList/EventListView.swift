//
//  EventListView.swift
//  Eventorias
//

import SwiftUI

struct EventListView: View {
    @EnvironmentObject var eventListViewModel: EventListViewModel
    
    var body: some View {
        ForEach(eventListViewModel.filteredEvents, id: \.id) { event in
            NavigationLink {
                EventDetailView(event: event)
            } label: {
                EventTileView(event: event)
            }

        }
    }
}

#Preview {
    let viewModel = EventListViewModel()
    EventListView()
        .environmentObject(viewModel)
}

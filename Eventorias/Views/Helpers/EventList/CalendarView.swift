//
//  CalendarView.swift
//  Eventorias
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var eventListViewModel: EventListViewModel
    
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(),spacing: 10)]) {
            ForEach(eventListViewModel.filteredEvents, id: \.id) { event in
                NavigationLink {
                    EventDetailView(event: event)
                } label : {
                    CalendarTileView(event: event)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    let viewModel = EventListViewModel()
    CalendarView()
        .environmentObject(viewModel)
}
